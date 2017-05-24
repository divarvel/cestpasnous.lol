{-# LANGUAGE OverloadedStrings #-}

import           Lucid              (Html, renderText)
import           Lucid.Html5
import           System.Environment (lookupEnv)
import           Web.Scotty

main :: IO ()
main = do
  port <- lookupEnv "PORT"
  scotty (maybe 8080 read port) $ do
    get "/:code" $ do
      --code <- param "code"
      html $ renderText (layout)

layout :: Html ()
layout = doctypehtml_ $ do
  h1_ $ "C'est pas nous, lol"
