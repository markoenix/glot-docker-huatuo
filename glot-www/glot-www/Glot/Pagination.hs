module Glot.Pagination
    ( Pagination(..)
    , paginationRequired
    , PageData(..)
    , fromPageData
    , PageLink(..)
    , toPageLinks
    ) where


import Prelude
import Data.Int (Int64)
import Data.Text (Text)

import qualified Data.Maybe as Maybe
import qualified Data.Text as Text


data Pagination = Pagination {
    paginationNextPage :: Maybe Text,
    paginationPrevPage :: Maybe Text,
    paginationFirstPage :: Maybe Text,
    paginationLastPage :: Maybe Text
} deriving (Show)

paginationRequired :: Pagination -> Bool
paginationRequired p = hasNext || hasPrev
    where hasNext = Maybe.isJust $ paginationNextPage p
          hasPrev = Maybe.isJust $ paginationPrevPage p


data PageLink = PageLink
    { pageLinkRel :: Text
    , pageLinkPage :: Text
    }

toPageLinks :: Pagination -> [PageLink]
toPageLinks Pagination{..} =
    Maybe.catMaybes
        [ fmap (PageLink "next") paginationNextPage
        , fmap (PageLink "prev") paginationPrevPage
        , fmap (PageLink "first") paginationFirstPage
        , fmap (PageLink "last") paginationLastPage
        ]


data PageData = PageData
    { currentPage :: Int
    , totalEntries :: Int64
    , entriesPerPage :: Int
    }

fromPageData :: PageData -> Pagination
fromPageData PageData{..} =
    let
        totalPages =
            ceiling (fromIntegral totalEntries / fromIntegral entriesPerPage :: Double)
    in
    if currentPage > totalPages then
        Pagination
            { paginationNextPage = Nothing
            , paginationPrevPage = Nothing
            , paginationFirstPage = Nothing
            , paginationLastPage = Nothing
            }

    else if currentPage == 1 && totalPages == 1 then
        Pagination
            { paginationNextPage = Nothing
            , paginationPrevPage = Nothing
            , paginationFirstPage = Nothing
            , paginationLastPage = Just (intToText totalPages)
            }

    else if currentPage == 1 && totalPages > 1 then
        Pagination
            { paginationNextPage = Just "2"
            , paginationPrevPage = Nothing
            , paginationFirstPage = Nothing
            , paginationLastPage = Just (intToText totalPages)
            }

    else if currentPage == totalPages then
        Pagination
            { paginationNextPage = Nothing
            , paginationPrevPage = Just (intToText (currentPage - 1))
            , paginationFirstPage = Just "1"
            , paginationLastPage = Nothing
            }

    else
        Pagination
            { paginationNextPage = Just (intToText (currentPage + 1))
            , paginationPrevPage = Just (intToText (currentPage - 1))
            , paginationFirstPage = Just "1"
            , paginationLastPage = Just (intToText totalPages)
            }


intToText :: Int -> Text
intToText n =
    Text.pack (show n)
