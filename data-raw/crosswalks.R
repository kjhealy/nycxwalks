## nyc_xwalk_df, nyc_xwalk_wide_df, nyc_xwalk_geographies_df,
## nyc_xwalk_boundaries_sf — NYC geography crosswalks built with
## nycbuildxwalks 0.0.0.9001 (see data-raw/crosswalks/build-crosswalks.R)

source(here::here("data-raw", "_source.R"))

run_meta <- read_json(here(rawpath, "run_meta.json"), simplifyVector = TRUE)
xwalk_meta <- read_json(
  here(rawpath, "crosswalks_meta.json"),
  simplifyVector = TRUE
)

# Geography IDs in nycbuildxwalks registry order.
geo_ids <- nycbuildxwalks::nyc_datasets$id

# -- Geographies -------------------------------------------------------------
source_agency <- c(
  dcp_zip = "NYC Department of City Planning",
  opendata_shapefile = "NYC Open Data",
  opendata_geojson = "NYC Open Data",
  edc_zip = "NYC Economic Development Corporation"
)

sources <- run_meta$datasets |>
  as_tibble() |>
  transmute(
    id,
    source_url = resolved_url,
    cycle = map_chr(cycle, \(x) if (length(x) == 0) NA_character_ else x)
  )

# -- Boundaries --------------------------------------------------------------
nyc_xwalk_boundaries_sf <- st_read(
  here(rawpath, "all_boundaries.geojson"),
  quiet = TRUE
) |>
  transmute(
    geo_id = id,
    geo_name = name_col,
    geo_name_alt = name_alt
  ) |>
  st_transform(crs = st_crs("EPSG:2263")) |>
  mutate(geo_id = factor(geo_id, levels = geo_ids)) |>
  arrange(geo_id, geo_name) |>
  mutate(geo_id = as.character(geo_id))

nyc_xwalk_geographies_df <- nycbuildxwalks::nyc_datasets |>
  transmute(
    geo_id = id,
    geo_name = dataset_name,
    source = unname(source_agency[source_type]),
    name_field = name_col,
    name_alt_field = name_alt
  ) |>
  left_join(sources, by = c(geo_id = "id")) |>
  left_join(
    nyc_xwalk_boundaries_sf |>
      st_drop_geometry() |>
      summarise(
        n_features = n(),
        n_names = n_distinct(geo_name),
        .by = geo_id
      ),
    by = "geo_id"
  ) |>
  mutate(run_date = as.Date(str_sub(run_id, 1, 10)))

# -- Long crosswalk ----------------------------------------------------------
longform <- fs::dir_ls(here(rawpath, "longform"), glob = "*.csv") |>
  map(\(f) {
    read_csv(
      f,
      col_types = cols(
        primary_geo_id = col_character(),
        primary_geo_name = col_character(),
        other_geo_id = col_character(),
        other_geo_name = col_character(),
        .default = col_double()
      )
    )
  }) |>
  list_rbind()

# Each feature's area after dissolving by name, as nycbuildxwalks computes
# primary areas. Computed from the boundaries because a few small features
# (removed by the -50 ft buffer) never appear as primaries.
feature_areas <- nyc_xwalk_boundaries_sf |>
  group_by(other_geo_id = geo_id, other_geo_name = geo_name) |>
  summarise(.groups = "drop") |>
  mutate(other_area_sqft = as.numeric(st_area(geometry))) |>
  st_drop_geometry()

nyc_xwalk_df <- longform |>
  left_join(feature_areas, by = c("other_geo_id", "other_geo_name")) |>
  mutate(pct_of_other = intersection_area_sqft / other_area_sqft * 100) |>
  relocate(other_area_sqft, .after = primary_area_sqft) |>
  mutate(
    across(c(primary_geo_id, other_geo_id), \(x) factor(x, levels = geo_ids))
  ) |>
  arrange(primary_geo_id, primary_geo_name, other_geo_id, desc(pct_overlap)) |>
  mutate(across(c(primary_geo_id, other_geo_id), as.character))

# -- Wide crosswalk ----------------------------------------------------------
nyc_xwalk_wide_df <- fs::dir_ls(here(rawpath, "wide"), glob = "*.csv") |>
  map(\(f) {
    primary <- str_match(basename(f), "^wide_(.+)_crosswalk\\.csv$")[, 2]
    read_csv(f, col_types = cols(.default = col_character())) |>
      rename(primary_geo_name = all_of(primary)) |>
      mutate(primary_geo_id = primary, .before = 1)
  }) |>
  list_rbind() |>
  select(primary_geo_id, primary_geo_name, any_of(geo_ids)) |>
  mutate(primary_geo_id = factor(primary_geo_id, levels = geo_ids)) |>
  arrange(primary_geo_id, primary_geo_name) |>
  mutate(primary_geo_id = as.character(primary_geo_id))

usethis::use_data(
  nyc_xwalk_df,
  nyc_xwalk_wide_df,
  nyc_xwalk_geographies_df,
  nyc_xwalk_boundaries_sf,
  overwrite = TRUE,
  compress = "xz"
)
