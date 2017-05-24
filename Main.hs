{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}
module Main where

import           Control.Monad.IO.Class (liftIO)
import           Data.Monoid            ((<>))
import           Data.Text              (Text, unpack)
import           Lucid                  (Html, renderText, toHtml)
import           Lucid.Html5
import           System.Environment     (lookupEnv)
import           Web.Scotty

main :: IO ()
main = do
  port <- lookupEnv "PORT"
  scotty (maybe 8080 read port) $ do
    get "/:a/:b" $ do
      a <- param "a"
      b <- param "b"
      liftIO . putStrLn $ unpack a <> " n'a rien à voir avec " <> unpack b
      html $ renderText (layout a b)

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
