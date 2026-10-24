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
