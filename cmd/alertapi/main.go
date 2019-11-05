package main

import (
	"github.com/YonghoChoi/depromeet-soboon/pkg/fcm"
	"github.com/labstack/echo"
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
	if err := c.Bind(msg); err != nil {
		res.Result = "500"
		res.Message = err.Error()
		return c.JSON(http.StatusOK, res)
	}

	if err := fcm.Send(msg); err != nil {
		res.Result = "500"
		res.Message = err.Error()
		return c.JSON(http.StatusOK, res)
	}

	res.Data["message"] = msg
	return c.JSON(http.StatusOK, res)
}
