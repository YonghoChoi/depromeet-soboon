package main

import (
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

	e.Logger.Fatal(e.Start(":8000"))
}
