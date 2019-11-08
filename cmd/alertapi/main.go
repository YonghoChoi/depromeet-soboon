package main

import (
	"github.com/YonghoChoi/depromeet-soboon/pkg/fcm"
	"github.com/YonghoChoi/depromeet-soboon/pkg/log"
	"github.com/labstack/echo"
	"github.com/mitchellh/mapstructure"
	"net/http"
)

const Version = "0.0.1"

type Response struct {
	Result  string                 `json:"result"`
	Message string                 `json:"message"`
	Data    map[string]interface{} `json:"data"`
}

func NewResponse() *Response {
	res := new(Response)
	res.Data = make(map[string]interface{})
	return res
}

func main() {
	log.Init("debug", "./alert-api.log")
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "This is soboon alert api")
	})

	e.GET("/version", func(c echo.Context) error {
		return c.String(http.StatusOK, Version)
	})

	e.POST("/api/alerts", Send)

	e.Logger.Fatal(e.Start(":8000"))
}

func Send(c echo.Context) error {
	msg := new(fcm.Message)
	res := NewResponse()
	res.Result = "200"

	data := echo.Map{}
	if err := c.Bind(&data); err != nil {
		res.Result = "500"
		res.Message = err.Error()
		log.Error("fcm", "invalid map type data. %v", res)
		return c.JSON(http.StatusOK, res)
	}
	log.Debug("fcm", "request data : %v", data)

	if err := mapstructure.Decode(data, msg); err != nil {
		res.Result = "500"
		res.Message = err.Error()
		log.Error("fcm", "request parameter parsing fail. %v", res)
		return c.JSON(http.StatusOK, res)
	}

	if err := fcm.Send(msg); err != nil {
		res.Result = "500"
		res.Message = err.Error()
		log.Error("fcm", "send fail. %v", res)
		return c.JSON(http.StatusOK, res)
	}

	res.Data["message"] = msg
	log.Debug("fcm", "send success. %v", res)
	return c.JSON(http.StatusOK, res)
}
