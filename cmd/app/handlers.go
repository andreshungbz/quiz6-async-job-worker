package main

import (
	"net/http"
)

// indexHandler returns JSON of a simple Hello World message.
func (app *application) indexHandler(w http.ResponseWriter, r *http.Request) {
	env := envelope{
		"message": "Hello world!",
	}

	err := app.writeJSON(w, http.StatusOK, env, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}
