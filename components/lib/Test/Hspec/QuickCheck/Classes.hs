{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Test.Hspec.QuickCheck.Classes
  ( testLaws
  ) where

import Control.Monad
  ( mapM_
  )
import Data.Function
  ( ($)
  , (.)
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

-- | Tests that the given type satisfies the laws of one or more typeclasses.
--
-- Example usage:
--
-- >>> testLaws @Natural [eqLaws, ordLaws]
-- >>> testLaws @(Map Int) [foldableLaws, functorLaws]
testLaws
  :: forall a
   . Typeable a
  => HasCallStack
  => [Proxy a -> Laws]
  -> Spec
testLaws = Hspec.describe specDescription . mapM_ testLawsFor
  where
    specDescription :: String
    specDescription = unwords ["Testing laws for", typeName]
      where
        typeName :: String
        typeName = show $ typeRep $ Proxy @a

    testLawsFor :: (Proxy a -> Laws) -> Spec
    testLawsFor toLaws =
      Hspec.describe typeclassName $
        mapM_ testNamedProperty namedProperties
      where
        laws :: Laws
        laws = toLaws Proxy

        namedProperties :: [(String, Property)]
        namedProperties = lawsProperties laws

        testNamedProperty :: (String, Property) -> Spec
        testNamedProperty (name, property) = Hspec.it name property

        typeclassName :: String
        typeclassName = lawsTypeclass laws
