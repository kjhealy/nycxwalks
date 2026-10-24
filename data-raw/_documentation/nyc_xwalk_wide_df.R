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
