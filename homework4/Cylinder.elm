module Cylinder exposing (..)

type alias Cylinder = { radius: Float, height: Float }

new: Cylinder
new =
  { radius = 1.0, height = 1.0 }

surfaceArea: Cylinder -> Float
surfaceArea c =
  2 * pi * c.radius * c.height + 2 * pi * c.radius ^ 2

volume: Cylinder -> Float
volume c =
  pi * c.radius ^ 2 * c.height

stretch: Float -> Cylinder -> Cylinder
stretch f c =
  let newHeight = c.height * f
  in {c | height = newHeight}

widen: Float -> Cylinder -> Cylinder
widen f c =
  let newRadius = c.radius * f
  in {c | radius = newRadius}
