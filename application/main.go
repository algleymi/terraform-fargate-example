package main

import (
	"net/http"

	"github.com/google/uuid"
)

func main() {
	server := CreateServer()
	server.ListenAndServe()
}

func CreateServer() *http.Server {
	router := CreateHandler()

	server := &http.Server{
		Addr:    ":80",
		Handler: router,
	}

	return server
}

func CreateHandler() *http.ServeMux {
	mux := http.NewServeMux()

	uniqueId := uuid.NewString()

	handler := func(res http.ResponseWriter, req *http.Request) {
		res.Write([]byte(uniqueId))
	}

	mux.HandleFunc("/", handler)

	return mux
}
