package main

import "core:fmt"
import "core:math"
import "vendor:sdl3"

Color :: [4]u8

main :: proc() {
  
  // begin initilization

  if !sdl3.Init({.VIDEO}) {
    fmt.println(sdl3.GetError())
    return
  }
  defer sdl3.Quit()

  window: ^sdl3.Window
  renderer: ^sdl3.Renderer

  sdl3.CreateWindowAndRenderer("EpicWindow", 100, 100, sdl3.WindowFlags{.RESIZABLE}, &window, &renderer)
  assert(window != nil)
  assert(renderer != nil)
  defer sdl3.DestroyWindow(window)
  defer sdl3.DestroyRenderer(renderer)
  
  // end initilization
  
  //main loop

  i:int = 0
  tick_loop: for {
    i += 1

    event:sdl3.Event
    for sdl3.PollEvent(&event) {
      if event.type == sdl3.EventType.QUIT {
        break tick_loop
      }
    }

    background_color: Color

    background_color.rgb = u8(abs(((i/20 + 128)%255) - 128))
    background_color.a = 255

    sdl3.SetRenderDrawColor(renderer, expand_values(background_color))
    sdl3.RenderClear(renderer)
    sdl3.RenderPresent(renderer)
  }
}
