package main

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

// routes returns the HTTP router with handlers set.
func (app *application) routes() http.Handler {
	router := httprouter.New()

	// Defined handlers for 404 and 205 status code
	router.NotFound = http.HandlerFunc(app.notFoundResponse)
	router.MethodNotAllowed = http.HandlerFunc(app.methodNotAllowedResponse)

	// Index route
	router.HandlerFunc(http.MethodGet, "/", app.indexHandler)

	return app.requestLogger(app.recoverPanic(router))
}
