package main

import "fmt"


type geometry interface {
    area() float64 // type area struct {
    perim() float64
}

// Struct definition
type Rectangle struct {
    Width  float64
    Height float64
}

// Method definition
func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func main() {
    rectangle := Rectangle{Width: 5.0, Height: 3.0}
    area := rectangle.Area()
    fmt.Println("Area:", area)
}
