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
