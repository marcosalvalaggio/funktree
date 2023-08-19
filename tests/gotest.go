package main

import "fmt"

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
