package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/google/uuid"
)

func main() {
	server := CreateServer()
	server.ListenAndServe()
}

func CreateServer() *http.Server {
	router := CreateHandler()

	server := &http.Server{
		Addr:    GetAddress(),
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

func GetAddress() string {
	var port string

	value, ok := os.LookupEnv("PORT")

	if !ok {
		port = "8080"
	} else {
		port = value
	}

	return fmt.Sprintf(":%s", port)
}
