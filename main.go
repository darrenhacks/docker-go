package main

import (
	"fmt"
	"os"
)

func main() {

	userId := os.Getuid()
	fmt.Printf("Hi! My user ID number is %d\n", userId)
}
