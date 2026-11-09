package main


import "core:fmt"
import "core:time"
import "core:os"
import "vendor:sdl3"


color :: [4]u8



main :: proc() {

  window:^sdl3.Window
  renderer: ^sdl3.Renderer
  sdl3.CreateWindowAndRenderer("SDL3 GPU - Odin", 1280, 720, sdl3.WindowFlags{}, &window, &renderer)
  defer(sdl3.DestroyWindow(window))
  defer(sdl3.DestroyRenderer(renderer))

  for i in 0..<sdl3.GetNumRenderDrivers() {
    fmt.println(sdl3.GetRenderDriver(i))
  }

  tick_loop: for i in 0..<10000000 {

    event:sdl3.Event
    for sdl3.PollEvent(&event) {
      if event.type == sdl3.EventType.QUIT  {
        break tick_loop
      }
    }


    backgroundColor : color

    backgroundColor.r = u8((i % 500)-250)
    backgroundColor.g = u8((i + 80) % 255)
    backgroundColor.b = u8((i + 160) % 255)
    backgroundColor.a = u8(255)

    sdl3.SetRenderDrawColor(renderer, expand_values(backgroundColor))
    sdl3.RenderClear(renderer)



    sdl3.RenderPresent(renderer)
  }
}
