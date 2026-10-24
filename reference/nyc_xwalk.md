# Crosswalk between two NYC geographies

Returns the rows of
[nyc_xwalk_df](https://kjhealy.github.io/nycxwalks/reference/nyc_xwalk_df.md)
for one primary geography and one or more other geographies: for each
feature of `from`, the overlapping features of `to`, with intersection
areas and the share of each feature they cover.

## Usage

``` r
nyc_xwalk(from, to = NULL, min_pct = 0)
```

## Arguments

- from:

  ID of the primary geography, e.g. `"cd"`. See
  [nyc_xwalk_geographies_df](https://kjhealy.github.io/nycxwalks/reference/nyc_xwalk_geographies_df.md)
  for the IDs.

- to:

  IDs of one or more other geographies, e.g. `"nta"`. `NULL` (the
  default) for all of them.

- min_pct:

  Keep only overlaps covering at least this percentage of the `from`
  feature (`pct_overlap`). Default `0`, keeping all.

## Value

A tibble with the columns of
[nyc_xwalk_df](https://kjhealy.github.io/nycxwalks/reference/nyc_xwalk_df.md),
sorted by `from` feature and decreasing `pct_overlap`.

## Examples

``` r
# NTAs in each community district
nyc_xwalk("cd", "nta")
#> # A tibble: 432 × 9
#>    primary_geo_id primary_geo_name other_geo_id other_geo_name primary_area_sqft
#>    <chr>          <chr>            <chr>        <chr>                      <dbl>
#>  1 cd             101              nta          Financial Dis…         41697017.
#>  2 cd             101              nta          Tribeca-Civic…         41697017.
#>  3 cd             101              nta          The Battery-G…         41697017.
#>  4 cd             101              nta          SoHo-Little I…         41697017.
#>  5 cd             101              nta          Chinatown-Two…         41697017.
#>  6 cd             102              nta          West Village           37724017.
#>  7 cd             102              nta          SoHo-Little I…         37724017.
#>  8 cd             102              nta          Greenwich Vil…         37724017.
#>  9 cd             103              nta          East Village           46878382.
#> 10 cd             103              nta          Lower East Si…         46878382.
#> # ℹ 422 more rows
#> # ℹ 4 more variables: other_area_sqft <dbl>, intersection_area_sqft <dbl>,
#> #   pct_overlap <dbl>, pct_of_other <dbl>

# Community districts in each NTA, keeping overlaps of 5% or more
nyc_xwalk("nta", "cd", min_pct = 5)
#> # A tibble: 295 × 9
#>    primary_geo_id primary_geo_name other_geo_id other_geo_name primary_area_sqft
#>    <chr>          <chr>            <chr>        <chr>                      <dbl>
#>  1 nta            Allerton         cd           211                    15754089.
#>  2 nta            Allerton         cd           212                    15754089.
#>  3 nta            Alley Pond Park  cd           411                    26132359.
#>  4 nta            Annadale-Huguen… cd           503                   180427583.
#>  5 nta            Arden Heights-R… cd           503                    67774045.
#>  6 nta            Astoria (Centra… cd           401                    21084822.
#>  7 nta            Astoria (East)-… cd           401                    26042025.
#>  8 nta            Astoria (North)… cd           401                    58301613.
#>  9 nta            Astoria Park     cd           401                     2674946.
#> 10 nta            Auburndale       cd           411                    55464034.
#> # ℹ 285 more rows
#> # ℹ 4 more variables: other_area_sqft <dbl>, intersection_area_sqft <dbl>,
#> #   pct_overlap <dbl>, pct_of_other <dbl>

# Every geography that overlaps police precincts
nyc_xwalk("pp")
#> # A tibble: 2,844 × 9
#>    primary_geo_id primary_geo_name other_geo_id other_geo_name primary_area_sqft
#>    <chr>          <chr>            <chr>        <chr>                      <dbl>
#>  1 pp             1                bid          Alliance for …         47284684.
#>  2 pp             1                bid          Hudson Square          47284684.
#>  3 pp             1                bid          SoHo Broadway          47284684.
#>  4 pp             1                cc           1                      47284684.
#>  5 pp             1                cc           3                      47284684.
#>  6 pp             1                cd           101                    47284684.
#>  7 pp             1                cd           102                    47284684.
#>  8 pp             1                dsny         MN01                   47284684.
#>  9 pp             1                dsny         MN02                   47284684.
#> 10 pp             1                fb           1                      47284684.
#> # ℹ 2,834 more rows
#> # ℹ 4 more variables: other_area_sqft <dbl>, intersection_area_sqft <dbl>,
#> #   pct_overlap <dbl>, pct_of_other <dbl>
```
