{-# LANGUAGE NoImplicitPrelude #-}
-- | Extended version of 'Test.Tasty.QuickCheck'.
module Test.Tasty.QuickCheck.Extended
  (
    module Test.Tasty.QuickCheck

    -- * Int's with a small, bounded domain.
  , SmallInt

    -- * Testing predicates
  , testPredicateDefinition
  ) where


import           Elevence.Prelude

import           Test.Tasty.QuickCheck
import qualified Test.Tasty.QuickCheck  as QC


------------------------------------------------------------------------------
-- Test utilities (TODO (SM): move)
------------------------------------------------------------------------------

-- | Test the definition of a predicate, while ensuring the we have enough
-- coverage of both the positive and negative test cases.
testPredicateDefinition :: (a -> Bool) -> (a -> Bool) -> (a -> QC.Property)
testPredicateDefinition impl referenceImpl x =
      QC.cover reference       20 "reference impl. accepts"
    $ QC.cover (not reference) 20 "reference impl. rejects"
    $ impl x == reference
  where
    reference = referenceImpl x



------------------------------------------------------------------------------
-- Testing the 'unique' and 'cyclic' functions.
------------------------------------------------------------------------------

-- | Small integers to ensure a good test distribution for the cyclicity test.
--
-- TODO (SM): generalize using a type level natural number and move to
-- 'Test.Tasty.QuickCheck.Extended'.
newtype SmallInt = SmallInt Int
    deriving (Eq, Ord, Show)

instance QC.Arbitrary SmallInt where
    arbitrary = (SmallInt . (`mod` 20)) <$> QC.arbitrary
