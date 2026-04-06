{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Test.Hspec.QuickCheck.Classes
  ( testLaws
  , testLawsMany
  ) where

import Control.Monad
  ( mapM_
  )
import Data.Function
  ( ($)
  )
import Data.List
  ( unwords
  )
import Data.Proxy
  ( Proxy (Proxy)
  )
import Data.String
  ( String
  )
import Data.Typeable
  ( Typeable
  , typeRep
  )
import GHC.Stack
  ( HasCallStack
  )
import Test.Hspec
  ( Spec
  )
import Test.QuickCheck
  ( Property
  )
import Test.QuickCheck.Classes
  ( Laws (lawsProperties, lawsTypeclass)
  )
import Text.Show
  ( Show (show)
  )

import qualified Test.Hspec as Hspec

-- | Tests that the given type satisfies the laws of a single typeclass.
--
-- Example usage:
--
-- >>> testLaws @Natural ordLaws
-- >>> testLaws @(Map Int) functorLaws
testLaws
  :: forall a
   . Typeable a
  => HasCallStack
  => (Proxy a -> Laws)
  -> Spec
testLaws getLaws =
  Hspec.describe specDescription $
    mapM_ testNamedProperty namedProperties
  where
    lawsToTest :: Laws
    lawsToTest = getLaws $ Proxy @a

    namedProperties :: [(String, Property)]
    namedProperties = lawsProperties lawsToTest

    specDescription :: String
    specDescription = unwords ["Testing", typeclassName, "laws for", typeName]

    testNamedProperty :: (String, Property) -> Spec
    testNamedProperty (name, property) = Hspec.it name property

    typeclassName :: String
    typeclassName = lawsTypeclass lawsToTest

    typeName :: String
    typeName = show (typeRep $ Proxy @a)

-- | Tests that the given type satisfies the laws of multiple typeclasses.
--
-- Example usage:
--
-- >>> testLawsMany @Natural [eqLaws, ordLaws]
-- >>> testLawsMany @(Map Int) [foldableLaws, functorLaws]
testLawsMany
  :: forall a
   . Typeable a
  => HasCallStack
  => [Proxy a -> Laws]
  -> Spec
testLawsMany getLawsMany =
  testLaws @a `mapM_` getLawsMany
