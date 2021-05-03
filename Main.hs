{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}

module Main where

import           Control.Monad.IO.Class  (liftIO)
import           Data.ByteString.Builder (toLazyByteString)
import           Data.Text               (Text, toLower, unpack)
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
    get "/" $
      html $ renderText form
    get "/style.css" $
      file "style.css"
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
isReserved = (`elem` ["cyril hanouna", "hanouna", "tpmp", "touche pas à mon poste", "manuel valls", "valls"]) . toLower

render :: Text -> Text -> Html ()
render a b
  | isReserved a = reserved a
  | isReserved b = reserved b
  | otherwise    = notme a b

layout :: Html () -> Html ()
layout content = doctypehtml_ $ do
  head_ $
    link_ [type_ "text/css", rel_ "stylesheet", href_ "/style.css"]
  body_ content

notme :: Text -> Text -> Html ()
notme a b = layout $
  h1_ $ do
    b_ $ toHtml a <> br_ []
    " n'a " <> i_ "rien" <> " à voir" <> br_ [] <> "avec "
    b_ (toHtml b) <> "."

reserved :: Text -> Html ()
reserved kw = layout $
  h1_ $ do
    "Se dédouaner de "
    b_ $ toHtml kw <> br_ []
    "est réservé aux utilisateurs premium. Merci de contacter le support"



form :: Html ()
form = layout $
  form_ [action_ "/", method_ "post"] $ do
    input_ [type_ "text", name_ "a", placeholder_ "@clementd"] <> br_ []
    input_ [type_ "text", name_ "b", placeholder_ "ce site inutile"] <> br_ []
    button_ [type_ "submit"] "Me dédouaner"
