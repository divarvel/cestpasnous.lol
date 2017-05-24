{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}

module Main where

import           Control.Monad.IO.Class  (liftIO)
import           Data.ByteString.Builder (toLazyByteString)
import           Data.Monoid             ((<>))
import           Data.Text               (Text, unpack)
import           Data.Text.Lazy.Encoding (decodeUtf8)
import           Lucid                   (Html, renderText, toHtml)
import           Lucid.Html5
import           Network.HTTP.Types.URI  (encodePathSegments)
import           System.Environment      (lookupEnv)
import           Web.Scotty

main :: IO ()
main = do
  port <- lookupEnv "PORT"
  scotty (maybe 8080 read port) $ do
    get "/" $ do
      html $ renderText form
    post "/" $ do
      a <- param "a"
      b <- param "b"
      redirect . decodeUtf8 . toLazyByteString $ encodePathSegments [a, b]
    get "/:a/:b" $ do
      a <- param "a"
      b <- param "b"
      liftIO . putStrLn $ unpack a <> " n'a rien à voir avec " <> unpack b
      html $ renderText (render a b)

isReserved :: Text -> Bool
isReserved = (`elem` ["Cyril Hanouna", "Hanouna", "TPMP", "Touche Pas à Mon Poste"])

render :: Text -> Text -> Html ()
render a b =
  if isReserved a then
    reserved a
  else if isReserved b then
    reserved b
  else layout a b

style :: Text
style =
  "margin-top: 200px;\n\
  \font-weight: normal;\n\
  \line-height: 1.4em;\n\
  \font-size: 100px;\n\
  \font-family: sans-serif;\n\
  \text-align: center;"


layout :: Text -> Text -> Html ()
layout a b = doctypehtml_ $ do
  h1_ [style_ style] $ do
    b_ $ toHtml a <> br_ []
    " n'a " <> i_ "rien" <> " à voir" <> br_ [] <> "avec "
    (b_ $ toHtml b) <> "."

reserved :: Text -> Html ()
reserved kw = doctypehtml_ $ do
  h1_ [style_ style] $ do
    "Se dédouaner de "
    b_ $ toHtml kw <> br_ []
    "est réservé aux utilisateurs premium. Merci de contacter le support"

inputStyle :: Text
inputStyle =
  "font-size: 5em;\n\
  \width: 90%;\n\
  \text-align: center;"

form :: Html ()
form = doctypehtml_ $ do
  form_ [action_ "/", method_ "post"] $ do
    input_ [type_ "text", name_ "a", style_ inputStyle] <> br_ []
    input_ [type_ "text", name_ "b", style_ inputStyle] <> br_ []
    button_ [type_ "submit", style_ inputStyle] "Me dédouaner"
