#!/usr/bin/env bash
#ARXIV_SANITY_DATA_ROOT=/data/james/arxiv-sanity
ARXIV_SANITY_DATA_ROOT=/home/james/projects/arxiv-sanity-docker/data

docker run -it --rm \
    --mount type=bind,source=$ARXIV_SANITY_DATA_ROOT,destination=/data/arxiv-sanity \
    -p 6785:6785 \
    arxiv-sanity
