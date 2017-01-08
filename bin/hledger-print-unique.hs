#!/usr/bin/env stack
{- stack runghc --verbosity info
   --package hledger-lib
   --package hledger
-}
-- You can compile this script for speed:
-- stack build hledger && stack ghc bin/hledger-print-unique.hs

{-
hledger-print-unique [-f JOURNALFILE | -f-]

Print only journal entries which are unique by description (or
something else). Reads the default or specified journal, or stdin.

-}

import Data.List
import Data.Ord
import Hledger.Cli

main = do
  putStrLn "(-f option not supported)"
  opts <- getCliOpts (defCommandMode ["hledger-print-unique"])
  withJournalDo opts $
    \opts j@Journal{jtxns=ts} -> print' opts j{jtxns=uniquify ts}
    where
      uniquify = nubBy (\t1 t2 -> thingToCompare t1 == thingToCompare t2) . sortBy (comparing thingToCompare)
      thingToCompare = tdescription
      -- thingToCompare = tdate