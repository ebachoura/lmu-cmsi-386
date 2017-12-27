import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Date exposing (..)

main =
  beginnerProgram { model = model, view = view, update = update }

type alias Model = { firstDate: String, secondDate: String }
type Msg = ChangeFirstDate String | ChangeSecondDate String

model : Model
model =
  { firstDate = "", secondDate = "" }

update : Msg -> Model -> Model
update msg model =
  case msg of
    ChangeFirstDate d -> { model | firstDate = d }
    ChangeSecondDate d -> { model | secondDate = d }


view : Model -> Html Msg
view model =
  body [ bodyStyle ] [
  h1 [ headerStyle ] [
    text "Date Calculator"
    ],
  p [] [
    text "From",
    input [ type_ "date", inputStyle, onInput ChangeFirstDate, value model.firstDate ] []
    ],
  p [] [
    text "to",
    input [ type_ "date", inputStyle, onInput ChangeSecondDate, value model.secondDate ] []
    ],
  p [] [
    text "is ",
    span [ outputStyle ] [
      text <| daysBetweenToString model.firstDate model.secondDate
    ],
    text " days."
    ]
  ]

-- Funtions
daysBetweenToString: String -> String -> String
daysBetweenToString firstDate secondDate =
  case (daysBetween firstDate secondDate) of
    Ok days -> toString <| days
    Err errorString -> ""

daysBetween: String -> String -> Result String Int
daysBetween date1 date2 =
  case (Date.fromString date1, Date.fromString date2) of
    (Ok d1, Ok d2) -> Ok <| floor ((toTime d2 - toTime d1) / 86400000)
    _ -> Err "There is something wrong with your input"


-- Style
bodyStyle =
  style
    [ ("background-color", "linen")
    , ("text-align", "center")
    , ("font", "16px Arial")
    , ("margin", "0px")
    ]

headerStyle =
  style
    [ ("background-color", "cyan")
    , ("margin-top", "0px")
    , ("font", "bold 40px Avenir")
    , ("padding", "5px")
    ]

inputStyle =
  style
    [ ("border", "2px solid grey")
    , ("margin-left", "8px")
    ]

outputStyle =
  style
    [ ("font-size", "28px") ]
