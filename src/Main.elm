module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (id, class, value, type_, placeholder)
import Html.Events exposing (onClick, onInput)
import Markdown
import Time
import Task


-- model
type alias Model =
    { articleList : List Article
    , editArticle : Article
    }


type alias Article =
    { title : String
    , markdown : String
    , lastupdated : String
    , tags : List String
    }


initialModel : Model
initialModel =
    { articleList = 
        [ { lastupdated = "", title = "hoge", markdown = "", tags = []}
        , { lastupdated = "", title = "foo", markdown = "", tags = []}
        , { lastupdated = "", title = "bar", markdown = "", tags = []}
        ]
    , editArticle = { lastupdated = "", title = "", markdown = "", tags = [] }
    }


-- msg
type Msg
    = ChangeArticle String


--update
update : Msg -> Model -> Model
update msg model =
    case msg of 
        ChangeArticle str ->
            { model | editArticle = ( Article model.editArticle.title str "20190727" model.editArticle.tags )}


-- view
view : Model -> Html Msg
view model =
   div [ class "container" ]
        [ siteHeader
        , articleList model
        , markdown model
        , siteFooter
        ]


articleList : Model -> Html Msg
articleList model = 
    div [ id "ArticleList"]
        [ ul [] ( List.map articleItem model.articleList )]


articleItem : Article -> Html Msg
articleItem article = 
    li [] [ text article.title ]


-- Markdown
markdown : Model -> Html Msg
markdown model = 
    section [ id "markdown" , class "markdown" ] 
        [ editor model
        , preview model
        ]


editor : Model -> Html Msg
editor model = 
    div [] 
        [ textarea [ class "editor" , value model.editArticle.markdown , onInput ChangeArticle ] [] 
        ]


preview : Model -> Html Msg
preview model = 
    div [ id "markdown-preview" ]
        <| Markdown.toHtml Nothing model.editArticle.markdown


siteHeader : Html Msg
siteHeader =
    header [] 
        [ p [] [ text "Hello world!" ]
        ]


siteFooter : Html Msg
siteFooter = 
    div [] []


-- main

main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
