module Warmup exposing (change, stripQuotes, powers, sumOfCubesOfOdds, daysBetween)
import Date exposing (..)

divmod: Int -> Int -> (Int, Int)
divmod x y = (x // y, x % y)

change: Int -> Result String (Int, Int, Int, Int)
change x =
  if x < 0 then
    Err "amount cannot be negative"
  else
    let
      (quarters, afterQuarters) = divmod x 25
      (dimes, afterDimes) = divmod afterQuarters 10
      (nickels, pennies) = divmod afterDimes 5
    in
      Ok <| (,,,) quarters dimes nickels pennies


stripQuotes: String -> String
stripQuotes s =
  String.filter (\c -> c /= '\'' && c /= '"') s

powers : Int -> Int -> Result String (List Int)
powers x y =
  if x < 0 then
    Err "negative base"
  else
    Ok (List.map (\s -> x ^ s) <| List.range 0 <| floor <| logBase (toFloat x) (toFloat y))

sumOfCubesOfOdds: List Int -> Int
sumOfCubesOfOdds list = List.filter (\x -> x % 2 /= 0) list
  |> List.map (\x -> x ^ 3)
  |> List.foldr (+) 0

daysBetween: String -> String -> Result String Int
daysBetween date1 date2 =
  case (Date.fromString date1, Date.fromString date2) of
    (Ok d1, Ok d2) -> Ok <| floor ((toTime d2 - toTime d1) / 86400000)
    _ -> Err "There is something wrong with your input"
