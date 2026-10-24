#' Boundaries used for the NYC geography crosswalks
#'
#' The boundaries of the fifteen geographies, as downloaded and combined to
#' compute the crosswalk tables.
#' EPSG:2263, NAD83 / New York Long Island (ftUS).
#'
#' @format ## `nyc_xwalk_boundaries_sf`
#' A simple feature collection with 1,155 rows and 4 columns:
#' \describe{
#'   \item{geo_id}{Geography ID (character). See
#'     [nyc_xwalk_geographies_df].}
#'   \item{geo_name}{Feature name, as in the crosswalk tables
#'     (character).}
#'   \item{geo_name_alt}{Alternate name (character). The district code for
#'     sanitation districts and the NTA code for NTAs. `NA` for the other
#'     geographies.}
#'   \item{geometry}{Polygon or MultiPolygon geometry in EPSG:2263.}
#' }
#' @details
#' The features are as published, not dissolved. One school district has
#' two features with the same name, and the crosswalks treat them as one
#' feature. nycbuildxwalks repaired invalid geometries with GEOS in planar
#' coordinates. The Historic Districts source labels State Plane
#' coordinates as longitude and latitude. nycbuildxwalks 0.0.0.9001 detects
#' this label and relabels the coordinates as EPSG:2263.
#'
#' Several of these geographies are not in the `nycmaps` package: business
#' improvement districts, historic districts, industrial business zones,
#' fire battalions, sanitation districts, and health center districts.
#' [nyc_xwalk_df] gives the credits for the crosswalk method.
#'
#' @author Kieran Healy
#' @source See [nyc_xwalk_geographies_df] for the source and release of
#'   each geography.
"nyc_xwalk_boundaries_sf"

#' NYC geography crosswalk (long format)
#'
#' How fifteen New York City administrative and statistical geographies
#' overlap. One row for each pair of features, one from a primary geography
#' and one from another geography, whose areas intersect, with the area of
#' the intersection and the share of each feature it covers.
#'
#' @format ## `nyc_xwalk_df`
#' A tibble with 38,323 rows and 9 columns:
#' \describe{
#'   \item{primary_geo_id}{ID of the primary geography, e.g. `"cd"`,
#'     `"nta"` (character). See [nyc_xwalk_geographies_df] for all 15.}
#'   \item{primary_geo_name}{Name of the primary feature (character). For
#'     numbered districts this is the number as the source gives it, e.g.
#'     community district `"101"` (borough code and district), police
#'     precinct `"14"`, council district `"33"`.}
#'   \item{other_geo_id}{ID of the other geography (character).}
#'   \item{other_geo_name}{Name of the other feature (character).}
#'   \item{primary_area_sqft}{Area of the primary feature in square feet
#'     (double).}
#'   \item{other_area_sqft}{Area of the other feature in square feet
#'     (double).}
#'   \item{intersection_area_sqft}{Area of the intersection in square feet
#'     (double). nycbuildxwalks shrinks the primary feature by 50 feet before
#'     it computes the intersection (see Details).}
#'   \item{pct_overlap}{Intersection as a percentage of the primary
#'     feature's area (double). For example, the share of a community
#'     district that lies in a given NTA.}
#'   \item{pct_of_other}{Intersection as a percentage of the other
#'     feature's area (double). For example, the share of an NTA that lies
#'     in a given community district.}
#' }
#' @details
#' Every geography is a primary geography in turn, so each pair appears in
#' both directions (e.g. `cd`-to-`nta` and `nta`-to-`cd`). The two directions
#' can differ slightly, because nycbuildxwalks applies the 50 ft buffer to
#' the primary feature only. Use [nyc_xwalk()] to get the rows for one pair
#' of geographies.
#'
#' **Method.** Computed with the nycbuildxwalks package (version 0.0.0.9001)
#' on 2026-10-24, in EPSG:2263 (NY State Plane, US feet):
#'
#' - nycbuildxwalks dissolves features with the same name into one feature
#'   before it computes overlaps. A multipart feature thus counts once.
#' - nycbuildxwalks shrinks each primary feature by 50 feet (a negative
#'   buffer) before it intersects the features. The buffer removes slivers
#'   along shared boundaries.
#' - nycbuildxwalks drops intersections of 100 square feet or less.
#' - `primary_area_sqft` and `other_area_sqft` are the areas of the
#'   dissolved features without the buffer.
#' - Five features are too narrow to survive the 50 ft buffer. They have no
#'   rows as primary features, but they appear as other features. The five
#'   features are the 47th Street (Diamond District Partnership) BID and
#'   four historic districts: St. Mark's Historic District Extension,
#'   Gramercy Park Historic District Extension, Sniffen Court, and
#'   Hardenbergh/Rhinelander.
#' - ZIP codes are DOHMH Modified ZIP Code Tabulation Areas (MODZCTAs), not
#'   USPS delivery areas.
#'
#' **Credits.** nycbuildxwalks is an R port of the Python NYC geography
#' crosswalks tool by Nathan Storey at MODA-NYC
#' (<https://github.com/MODA-NYC/nyc-geography-crosswalks>), which builds on
#' the concepts and data aggregation methods of the BetaNYC NYC Boundaries
#' Map (<https://github.com/BetaNYC/nyc-boundaries>). The boundaries come
#' from the NYC Department of City Planning, NYC Open Data, and the NYC
#' Economic Development Corporation. [nyc_xwalk_geographies_df] gives the
#' source and release of each geography.
#'
#' @author Kieran Healy
#' @source Built with nycbuildxwalks,
#'   <https://github.com/kjhealy/nycbuildxwalks>, after the MODA-NYC
#'   crosswalks tool, <https://github.com/MODA-NYC/nyc-geography-crosswalks>.
"nyc_xwalk_df"

#' Geographies in the NYC crosswalks
#'
#' The fifteen geographies in the crosswalk tables, with the source and
#' release of the boundaries used for each.
#'
#' @format ## `nyc_xwalk_geographies_df`
#' A tibble with 15 rows and 10 columns:
#' \describe{
#'   \item{geo_id}{Geography ID used in the crosswalk tables (character):
#'     `cd` community districts, `pp` police precincts, `dsny` sanitation
#'     districts, `fb` fire battalions, `sd` school districts, `hc` health
#'     center districts, `cc` city council districts, `nycongress`
#'     congressional districts, `sa` state assembly districts, `ss` state
#'     senate districts, `bid` business improvement districts, `nta` 2020
#'     Neighborhood Tabulation Areas, `zipcode` Modified ZIP Code Tabulation
#'     Areas, `hd` historic districts, `ibz` industrial business zones.}
#'   \item{geo_name}{Name of the geography (character).}
#'   \item{source}{Publisher of the boundaries: NYC Department of City
#'     Planning, NYC Open Data, or NYC Economic Development Corporation
#'     (character).}
#'   \item{name_field}{Field in the source data used for feature names
#'     (character).}
#'   \item{name_alt_field}{Field used for alternate names, where there is
#'     one (character).}
#'   \item{source_url}{URL from which nycbuildxwalks downloaded the
#'     boundaries (character).}
#'   \item{cycle}{DCP release cycle of the boundaries, e.g. `"25d"`, for
#'     DCP sources (character). `NA` for other sources.}
#'   \item{n_features}{Number of boundary features (integer).}
#'   \item{n_names}{Number of distinct feature names, i.e. features after
#'     dissolving by name (integer).}
#'   \item{run_date}{Date on which nycbuildxwalks downloaded the boundaries
#'     and built the crosswalks (Date).}
#' }
#' @details
#' [nyc_xwalk_df] gives the credits for the crosswalk method.
#'
#' @author Kieran Healy
#' @source NYC Department of City Planning, BYTES of the BIG APPLE,
#'   <https://www.nyc.gov/content/planning/pages/resources>. NYC Open Data,
#'   <https://opendata.cityofnewyork.us>. NYC Economic Development
#'   Corporation, <https://edc.nyc>. The registry comes from nycbuildxwalks,
#'   which adapts it from the MODA-NYC crosswalks tool,
#'   <https://github.com/MODA-NYC/nyc-geography-crosswalks>.
"nyc_xwalk_geographies_df"

#' NYC geography crosswalk (wide format)
#'
#' For every feature of every geography, the names of the overlapping
#' features in each of the other fourteen geographies. One row per feature,
#' one column per geography.
#'
#' @format ## `nyc_xwalk_wide_df`
#' A tibble with 1,154 rows and 17 columns:
#' \describe{
#'   \item{primary_geo_id}{ID of the primary geography (character). See
#'     [nyc_xwalk_geographies_df].}
#'   \item{primary_geo_name}{Name of the primary feature (character).}
#'   \item{cd,pp,dsny,fb,sd,hc,cc,nycongress,sa,ss,bid,nta,zipcode,hd,ibz}{Names
#'     of the overlapping features in that geography, sorted and separated
#'     by `";"`, e.g. `"MN01;MN03"` (character). `NA` if none overlap, and
#'     in the primary geography's own column.}
#' }
#' @details
#' The same overlaps as [nyc_xwalk_df], without areas, in the layout of the
#' wide CSV files published by nycbuildxwalks and the MODA-NYC crosswalks
#' tool. Use [nyc_xwalk_df] for intersection areas and shares.
#' [nyc_xwalk_df] describes the method and gives the credits.
#'
#' @author Kieran Healy
#' @source Built with nycbuildxwalks,
#'   <https://github.com/kjhealy/nycbuildxwalks>, after the MODA-NYC
#'   crosswalks tool, <https://github.com/MODA-NYC/nyc-geography-crosswalks>.
"nyc_xwalk_wide_df"

