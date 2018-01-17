#!/usr/bin/env bash
ARXIV_SANITY_DATA_ROOT=/data/james/arxiv-sanity

docker run -it --rm \
    --mount type=bind,source=$ARXIV_SANITY_DATA_ROOT,destination=/data/arxiv-sanity \
    arxiv-sanity
