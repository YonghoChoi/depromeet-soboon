package main

import (
	"github.com/YonghoChoi/depromeet-soboon/pkg/fcm"
	"github.com/labstack/echo"
	"net/http"
)

const Version = "0.0.1"

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
	if err := c.Bind(msg); err != nil {
		return err
	}

	if err := fcm.Send(msg); err != nil {
		return err
	}

	return c.JSON(http.StatusOK, msg)
}
