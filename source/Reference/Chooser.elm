module Reference.Chooser exposing (..)

import Html exposing (node, div, text, pre, code)
import Html.App
import String

import Ui.Container
import Ui.Chooser
import Ui

import Reference.Form as Form exposing (valueOfCheckbox, valueOfInput)

import Components.Reference

type Msg
  = Form Form.Msg
  | Chooser Ui.Chooser.Msg

type alias Model =
  { model : Ui.Chooser.Model
  , fields : Form.Model
  }

data =
  [ { label = "Star Wars: Episode I",   value = "star_wars_1" }
  , { label = "Star Wars: Episode II",  value = "star_wars_2" }
  , { label = "Star Wars: Episode III", value = "star_wars_3" }
  , { label = "Star Wars: Episode IV",  value = "star_wars_4" }
  , { label = "Star Wars: Episode V",   value = "star_wars_5" }
  , { label = "Star Wars: Episode VI",  value = "star_wars_6" }
  , { label = "Star Wars: Episode VII", value = "star_wars_7" }
  ]

init =
  { model = Ui.Chooser.init data "Placeholder..." ""
  , fields = Form.init { checkboxes = [ ("disabled", 1, False)
                                        , ("searchable", 0, False)
                                        , ("multiple", 0, False)
                                        , ("open", 0, False)
                                        , ("closeOnSelect", 0, False)
                                        , ("deselectable", 0, False)
                                        ]
                         , choosers = []
                         , inputs = [("placeholder", 2, "Placeholder...", "Placeholder...")]
                         }
  }

update action model =
  case action of
    Form act ->
      let
        (fields, effect) = Form.update act model.fields
      in
        ({ model | fields = fields }, Cmd.map Form effect)
          |> updateState

    Chooser act ->
      let
        (chooser, effect) = Ui.Chooser.update act model.model
      in
        ({ model | model = chooser }, Cmd.map Chooser effect)
          |> updateFields

updateFields (model, effect) =
  ({ model | fields = Form.updateCheckbox "open" model.model.open model.fields }, effect)

updateState (model, effect) =
  let
    updatedButton button =
      { button | disabled      = valueOfCheckbox "disabled"      False model.fields
               , placeholder   = valueOfInput    "placeholder"   ""    model.fields
               , searchable    = valueOfCheckbox "searchable"    False model.fields
               , open          = valueOfCheckbox "open"          False model.fields
               , multiple      = valueOfCheckbox "multiple"      False model.fields
               , closeOnSelect = valueOfCheckbox "closeOnSelect" False model.fields
               , deselectable  = valueOfCheckbox "deselectable"  False model.fields
      }
  in
    ({ model | model = updatedButton model.model }, effect)


modelCodeString = """
{ placeholder : String
, searchable : Bool
, closeOnSelect : Bool
, deselectable: Bool
, disabled : Bool
, multiple : Bool
, data : List Item
, render : Ui.Chooser.Item -> Html
}
"""

playground children =
  node "docs-playground" [] children

infos =
  [ Ui.title [] [text "Chooser"]
  , div [] [text "Chooser is a kind of select."]
  , Ui.title [] [text "Model"]
  , pre [] [code [] [text (String.trim modelCodeString)]]
  ]

fields model =
  Html.App.map Form (Form.view model.fields)

view model =
  Html.App.map Chooser (Ui.Chooser.view model.model)

render model =
  Components.Reference.view (view model) (fields model)