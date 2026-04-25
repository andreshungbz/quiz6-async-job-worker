package main

import (
	"fmt"
	"net/http"
)

// recoverPanic ensures that in the case of a panic, a Connection header of
// 'close' is sent to the client.
func (app *application) recoverPanic(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			pv := recover()
			if pv != nil {
				w.Header().Set("Connection", "close")
				app.serverErrorResponse(w, r, fmt.Errorf("%v", pv))
			}
		}()

		next.ServeHTTP(w, r)
	})
}

// requestLogger logs the HTTP request's method and URL path.
func (app *application) requestLogger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		app.logger.Info("Request received", "method", r.Method, "path", r.URL.Path)
		next.ServeHTTP(w, r)
	})
}
