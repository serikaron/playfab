package main

import (
	"log"
	"net/http"
	"time"
)

func main() {
	goOn := true
	for goOn {
		rsp, err := http.Get("http://external-server/user/get?id=12345")
		log.Println(err)
		log.Println(rsp)
		goOn = err != nil
		time.Sleep(time.Second)
	}
}
