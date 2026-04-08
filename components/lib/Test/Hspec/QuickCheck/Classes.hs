{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Test.Hspec.QuickCheck.Classes
  ( testLaws
  ) where

import Data.Kind
  ( Type
  )
import Data.Proxy
  ( Proxy (Proxy)
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

import qualified Test.Hspec as Hspec

_importsRequiredForHaddock :: ()
_importsRequiredForHaddock = undefined
  where
    _type :: Type
    _type = undefined

-- | Tests that a type satisfies the laws of one or more typeclasses.
--
-- For example, to test that 'Bool' satisfies the laws of 'Eq', 'Ord', and
-- 'Show':
--
-- @
-- 'testLaws' \@'Bool'
--   [ 'Test.QuickCheck.Classes.eqLaws'
--   , 'Test.QuickCheck.Classes.ordLaws'
--   , 'Test.QuickCheck.Classes.showLaws'
--   ]
-- @
--
-- === Kind polymorphism
--
-- The 'testLaws' function can also test instances of type classes whose type
-- parameters are not of kind 'Type'.
--
-- For example, with 'Maybe', which has kind @'Type' -> 'Type'@:
--
-- @
-- 'testLaws' \@'Maybe'
--   [ 'Test.QuickCheck.Classes.applicativeLaws'
--   , 'Test.QuickCheck.Classes.functorLaws'
--   , 'Test.QuickCheck.Classes.monadLaws'
--   , 'Test.QuickCheck.Classes.foldableLaws'
--   , 'Test.QuickCheck.Classes.traversableLaws'
--   ]
-- @
--
-- And with 'Either', which has kind @'Type' -> 'Type' -> 'Type'@:
--
-- @
-- 'testLaws' \@'Either'
--   [ 'Test.QuickCheck.Classes.bifoldableLaws'
--   , 'Test.QuickCheck.Classes.bifunctorLaws'
--   , 'Test.QuickCheck.Classes.bitraversableLaws'
--   ]
-- @
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
