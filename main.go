package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func main() {
	app := fiber.New()

	app.Use(cors.New())

	app.Use(func(c *fiber.Ctx) error {
		logString := fmt.Sprintf("%s - [%s] \"%s %s %s\" %d\n",
			c.IP(), time.Now().Format("02/Jan/2006:15:04:05 -0700"), c.Method(), c.Path(), c.Protocol(), c.Response().StatusCode)

		fmt.Println(logString)

		return c.Next()
	})

	app.Get("/", func(c *fiber.Ctx) error {
		content, err := ioutil.ReadFile("get.sh")
		if err != nil {
			log.Println(err)
			return c.SendStatus(http.StatusInternalServerError)
		}

		return c.SendString(string(content))
	})

	app.Get("/setup", func(c *fiber.Ctx) error {
		content, err := ioutil.ReadFile("validator.sh")
		if err != nil {
			log.Println(err)
			return c.SendStatus(http.StatusInternalServerError)
		}

		return c.SendString(string(content))
	})

	log.Fatal(app.Listen(":3033"))
}
