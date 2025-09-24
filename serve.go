// build cmd:
// go build -ldflags "-s -w" serve.go
package main


import (
	"fmt"
	"net/http"
	"os"
)


func main() {
	path := "."
	port := "8080"

	if len(os.Args) == 2 {
		path = os.Args[1]
	}

	if len(os.Args) == 3 {
		path = os.Args[1]
		port = os.Args[2]
	}

	http.Handle("/", http.FileServer(http.Dir(path)))

	fmt.Printf("serving at: http://localhost:%s\n", port)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        fmt.Println()
        fmt.Println(err)
        os.Exit(1)
    }
}
