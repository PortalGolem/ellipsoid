package main

import "core:fmt"
import "core:math"
import "vendor:sdl3"

Color :: [4]u8
Vector3 :: [3]f16
Ellipse :: [2]Vector3

main :: proc() {
 
  Ellipses : [dynamic]Ellipse
  defer(free(&Ellipses))

  
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

  surface := CreateSurfaceFromWindowSize(window)

  texture := CreateTextureFromWindowSize(window, renderer)

  // magic inputs

  rect := sdl3.Rect {
    x = 50,
    y = 50,
    w = 500,
    h = 500,
  }


  append(&Ellipses, Ellipse {{100.0, 100.0, 100.0}, {0.0, 0.0, 0.0}})
 
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
      if event.type == sdl3.EventType.WINDOW_RESIZED {
        surface = CreateSurfaceFromWindowSize(window)
        texture = CreateTextureFromWindowSize(window, renderer)
      }
    }

    for ellipse in Ellipses {
      RenderPoint(surface, i32(ellipse[0].x), i32(ellipse[0].y), 10, 0x000000FF)
      RenderPoint(surface, i32(ellipse[1].x), i32(ellipse[1].y), 10, 0x000000FF)
    }
    
    sdl3.UpdateTexture(texture, nil, surface.pixels, surface.pitch)

    background_color: Color

    background_color.rgb = u8(abs(((i/20 + 128)%255) - 128))
    background_color.a = 255

    sdl3.SetRenderDrawColor(renderer, expand_values(background_color))
    sdl3.RenderClear(renderer)

    sdl3.RenderTexture(renderer, texture, nil, nil)

    sdl3.RenderPresent(renderer)
  }
}

RenderPoint :: proc(surface:^sdl3.Surface, x:i32, y:i32, size:i32, color:u32) {
  point := sdl3.Rect {x = x - size/2, y = y - size/2, w = size, h = size}
  sdl3.FillSurfaceRect(surface, &point, color)
}

CreateSurfaceFromWindowSize :: proc(window:^sdl3.Window) -> ^sdl3.Surface {
  windowWidth:i32
  windowHeight:i32

  sdl3.GetWindowSizeInPixels(window, &windowWidth, &windowHeight)
  return sdl3.CreateSurface(windowWidth, windowHeight, .RGBA8888)
}

CreateTextureFromWindowSize :: proc(window:^sdl3.Window, renderer:^sdl3.Renderer) -> ^sdl3.Texture {
  textureWidth:i32
  textureHeight:i32

  sdl3.GetWindowSizeInPixels(window, &textureWidth, &textureHeight)
  return sdl3.CreateTexture(
    renderer,
    .RGBA8888,
    .STREAMING,
    textureWidth,
    textureHeight
  )
}
