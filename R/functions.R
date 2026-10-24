#' Crosswalk between two NYC geographies
#'
#' Returns the rows of [nyc_xwalk_df] for one primary geography and one or
#' more other geographies: for each feature of `from`, the overlapping
#' features of `to`, with intersection areas and the share of each feature
#' they cover.
#'
#' @param from ID of the primary geography, e.g. `"cd"`. See
#'   [nyc_xwalk_geographies_df] for the IDs.
#' @param to IDs of one or more other geographies, e.g. `"nta"`. `NULL`
#'   (the default) for all of them.
#' @param min_pct Keep only overlaps covering at least this percentage of
#'   the `from` feature (`pct_overlap`). Default `0`, keeping all.
#'
#' @return A tibble with the columns of [nyc_xwalk_df], sorted by `from`
#'   feature and decreasing `pct_overlap`.
#'
#' @export
#'
#' @examples
#' # NTAs in each community district
#' nyc_xwalk("cd", "nta")
#'
#' # Community districts in each NTA, keeping overlaps of 5% or more
#' nyc_xwalk("nta", "cd", min_pct = 5)
#'
#' # Every geography that overlaps police precincts
#' nyc_xwalk("pp")
nyc_xwalk <- function(from, to = NULL, min_pct = 0) {
  geo_ids <- nycxwalks::nyc_xwalk_geographies_df$geo_id
  from <- rlang::arg_match(from, geo_ids)
  if (!is.null(to)) {
    to <- rlang::arg_match(to, geo_ids, multiple = TRUE)
  }
  if (!is.numeric(min_pct) || length(min_pct) != 1 || is.na(min_pct)) {
    cli::cli_abort("{.arg min_pct} must be a single number.")
  }

  xwalk <- nycxwalks::nyc_xwalk_df
  keep <- xwalk$primary_geo_id == from &
    xwalk$pct_overlap >= min_pct &
    (is.null(to) | xwalk$other_geo_id %in% to)
  out <- xwalk[keep, ]
  out[order(out$primary_geo_name, out$other_geo_id, -out$pct_overlap), ]
}
