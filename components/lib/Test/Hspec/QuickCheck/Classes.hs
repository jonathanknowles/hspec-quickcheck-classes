{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Test.Hspec.QuickCheck.Classes
  ( testLaws
  , testLawsMany
  ) where

import Control.Monad
  ( forM_
  , mapM_
  )
import Data.Function
  ( ($)
  )
import Data.Monoid
  ( Monoid (mconcat)
  )
import Data.Proxy
  ( Proxy (Proxy)
  )
import Data.Tuple
  ( uncurry
  )
import Data.Typeable
  ( Typeable
  , typeRep
  )
import Test.Hspec
  ( Spec
  , describe
  , it
  , parallel
  )
import Test.QuickCheck.Classes
  ( Laws (lawsProperties, lawsTypeclass)
  )
import Text.Show
  ( Show (show)
  )

-- | Tests that the given type satisfies the laws of a single typeclass.
--
-- Example usage:
--
-- >>> testLaws @Natural ordLaws
-- >>> testLaws @(Map Int) functorLaws
testLaws
  :: forall a
   . Typeable a
  => (Proxy a -> Laws)
  -> Spec
testLaws getLaws =
  parallel $
    describe description $
      forM_ (lawsProperties laws) $
        uncurry it
  where
    description =
      mconcat
        [ "Testing "
        , lawsTypeclass laws
        , " laws for type "
        , show (typeRep $ Proxy @a)
        ]
    laws = getLaws $ Proxy @a

-- | Tests that the given type satisfies the laws of multiple typeclasses.
--
-- Example usage:
--
-- >>> testLawsMany @Natural [eqLaws, ordLaws]
-- >>> testLawsMany @(Map Int) [foldableLaws, functorLaws]
testLawsMany
  :: forall a
   . Typeable a
  => [Proxy a -> Laws]
  -> Spec
testLawsMany getLawsMany =
  testLaws @a `mapM_` getLawsMany
