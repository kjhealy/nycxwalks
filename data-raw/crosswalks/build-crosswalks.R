## Build NYC geography crosswalks with nycbuildxwalks (>= 0.0.0.9001).
##
## make_run() downloads the 15 boundary layers from DCP, NYC Open Data, and
## NYC EDC, combines them into outputs/<run>/all_boundaries.geojson, and
## writes one longform and one wide crosswalk CSV per primary geography,
## with run_meta.json (sources, cycles) and crosswalks_meta.json
## (thresholds).
##
## Version 0.0.0.9001 fixes two problems with the current sources: the
## Historic Districts GeoJSON has State Plane coordinates labelled as
## EPSG:4326, and the Business Improvement Districts name column changed.
##
## Run from this folder: R --quiet -f build-crosswalks.R

library(nycbuildxwalks)

stopifnot(packageVersion("nycbuildxwalks") >= "0.0.0.9001")

run_dir <- make_run(output_dir = "outputs")
