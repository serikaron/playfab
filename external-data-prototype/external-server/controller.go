package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type Controller struct {
	dao *Dao
}

func (c *Controller) Start() {
	http.HandleFunc("/user/get", c.getUser)
	http.HandleFunc("/user/set", c.setUser)

	log.Fatalln(http.ListenAndServe("0.0.0.0:80", nil))
}

func (c *Controller) getParamFrom(request *http.Request, key string) string {
	p, ok := request.URL.Query()[key]
	if !ok || len(p) < 1 {
		return fmt.Sprintf("get %s failed", key)
	} else {
		return p[0]
	}
}

func (c *Controller) getUser(writer http.ResponseWriter, request *http.Request) {
	writer.Header().Set("Access-Control-Allow-Origin", "*")
	id := c.getParamFrom(request, "id")
	name, err := c.dao.GetUser(id)
	if err != nil {
		writer.Write(bytes.NewBufferString("Name not found").Bytes())
	} else {
		writer.Write(bytes.NewBufferString(fmt.Sprintf("your name %s", name)).Bytes())
	}
}

type setUserRequest struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

func (r *setUserRequest) String() string {
	return fmt.Sprintf("id:%s name:%s", r.ID, r.Name)
}

func (c *Controller) setUser(writer http.ResponseWriter, request *http.Request) {
	writer.Header().Set("Access-Control-Allow-Origin", "*")
	//log.Println("setUser")
	if request.Method != "POST" {
		log.Println(fmt.Sprintf("not a post method, %s", request.Method))
		writer.Write(bytes.NewBufferString("not a post method").Bytes())
		return
	}

	//log.Println("setUser1")
	var req setUserRequest
	if err := json.NewDecoder(request.Body).Decode(&req); err != nil {
		//log.Println(request.Body)
		//log.Println(fmt.Sprintf("%v", err))
		writer.Write(bytes.NewBufferString(fmt.Sprintf("%v", err)).Bytes())
		return
	}

	log.Println(req)
	log.Println(c.dao.SetUser(req.ID, req.Name))
	writer.Write(bytes.NewBufferString("ok").Bytes())
}
