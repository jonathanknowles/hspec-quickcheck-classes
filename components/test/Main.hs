{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Main (main) where

import Data.Bool
  ( Bool
  )
import Data.Either
  ( Either
  )
import Data.Function
  ( ($)
  )
import Data.Maybe
  ( Maybe
  )
import System.IO
  ( IO
  )
import Test.Hspec
  ( hspec
  )
import Test.Hspec.QuickCheck.Classes
  ( testLaws
  )
import Test.QuickCheck.Classes
  ( alternativeLaws
  , applicativeLaws
  , bifoldableLaws
  , bifunctorLaws
  , bitraversableLaws
  , eqLaws
  , foldableLaws
  , functorLaws
  , monadLaws
  , ordLaws
  , showLaws
  , showReadLaws
  , traversableLaws
  )

main :: IO ()
main = hspec $ do
  -- Demonstrates usage with an argument of kind 'Type':
  testLaws @Bool
    [ eqLaws
    , ordLaws
    , showLaws
    , showReadLaws
    ]
  -- Demonstrates usage with an argument of kind 'Type -> Type':
  testLaws @Maybe
    [ alternativeLaws
    , applicativeLaws
    , functorLaws
    , monadLaws
    , foldableLaws
    , traversableLaws
    ]
  -- Demonstrates usage with an argument of kind 'Type -> Type -> Type':
  testLaws @Either
    [ bifoldableLaws
    , bifunctorLaws
    , bitraversableLaws
    ]
