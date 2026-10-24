# NYC geography crosswalk (long format)

How fifteen New York City administrative and statistical geographies
overlap. One row for each pair of features, one from a primary geography
and one from another geography, whose areas intersect, with the area of
the intersection and the share of each feature it covers.

## Usage

``` r
nyc_xwalk_df
```

## Format

### `nyc_xwalk_df`

A tibble with 38,323 rows and 9 columns:

- primary_geo_id:

  ID of the primary geography, e.g. `"cd"`, `"nta"` (character). See
  [nyc_xwalk_geographies_df](https://kjhealy.github.io/nycxwalks/reference/nyc_xwalk_geographies_df.md)
  for all 15.

- primary_geo_name:

  Name of the primary feature (character). For numbered districts this
  is the number as the source gives it, e.g. community district `"101"`
  (borough code and district), police precinct `"14"`, council district
  `"33"`.

- other_geo_id:

  ID of the other geography (character).

- other_geo_name:

  Name of the other feature (character).

- primary_area_sqft:

  Area of the primary feature in square feet (double).

- other_area_sqft:

  Area of the other feature in square feet (double).

- intersection_area_sqft:

  Area of the intersection in square feet (double). nycbuildxwalks
  shrinks the primary feature by 50 feet before it computes the
  intersection (see Details).

- pct_overlap:

  Intersection as a percentage of the primary feature's area (double).
  For example, the share of a community district that lies in a given
  NTA.

- pct_of_other:

  Intersection as a percentage of the other feature's area (double). For
  example, the share of an NTA that lies in a given community district.

## Source

Built with nycbuildxwalks, <https://github.com/kjhealy/nycbuildxwalks>,
after the MODA-NYC crosswalks tool,
<https://github.com/MODA-NYC/nyc-geography-crosswalks>.

## Details

Every geography is a primary geography in turn, so each pair appears in
both directions (e.g. `cd`-to-`nta` and `nta`-to-`cd`). The two
directions can differ slightly, because nycbuildxwalks applies the 50 ft
buffer to the primary feature only. Use
[`nyc_xwalk()`](https://kjhealy.github.io/nycxwalks/reference/nyc_xwalk.md)
to get the rows for one pair of geographies.

**Method.** Computed with the nycbuildxwalks package (version
0.0.0.9001) on 2026-10-24, in EPSG:2263 (NY State Plane, US feet):

- nycbuildxwalks dissolves features with the same name into one feature
  before it computes overlaps. A multipart feature thus counts once.

- nycbuildxwalks shrinks each primary feature by 50 feet (a negative
  buffer) before it intersects the features. The buffer removes slivers
  along shared boundaries.

- nycbuildxwalks drops intersections of 100 square feet or less.

- `primary_area_sqft` and `other_area_sqft` are the areas of the
  dissolved features without the buffer.

- Five features are too narrow to survive the 50 ft buffer. They have no
  rows as primary features, but they appear as other features. The five
  features are the 47th Street (Diamond District Partnership) BID and
  four historic districts: St. Mark's Historic District Extension,
  Gramercy Park Historic District Extension, Sniffen Court, and
  Hardenbergh/Rhinelander.

- ZIP codes are DOHMH Modified ZIP Code Tabulation Areas (MODZCTAs), not
  USPS delivery areas.

**Credits.** nycbuildxwalks is an R port of the Python NYC geography
crosswalks tool by Nathan Storey at MODA-NYC
(<https://github.com/MODA-NYC/nyc-geography-crosswalks>), which builds
on the concepts and data aggregation methods of the BetaNYC NYC
Boundaries Map (<https://github.com/BetaNYC/nyc-boundaries>). The
boundaries come from the NYC Department of City Planning, NYC Open Data,
and the NYC Economic Development Corporation.
[nyc_xwalk_geographies_df](https://kjhealy.github.io/nycxwalks/reference/nyc_xwalk_geographies_df.md)
gives the source and release of each geography.

## Author

Kieran Healy
