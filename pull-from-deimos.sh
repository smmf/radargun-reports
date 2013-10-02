#!/bin/bash

if [ x"$1" == x"" ]; then
    echo "Must choose a directory to put the files in..."
    exit
fi

TARGET="$1"

if [ -e "${TARGET}" ]; then
    if [ ! -d "${TARGET}" ]; then
        echo "Target ${TARGET} exists and IS NOT a directory!"
        exit
    fi
else
    mkdir "${TARGET}"
    mkdir "${TARGET}/reports"
    mkdir "${TARGET}/logs"
fi

rsync -avz deimos:github/radargun/target/distribution/RadarGun-1.1.0-SNAPSHOT/reports/* "${TARGET}/reports"

rsync -avz deimos:github/radargun/target/distribution/RadarGun-1.1.0-SNAPSHOT/*.out deimos:github/radargun/target/distribution/RadarGun-1.1.0-SNAPSHOT/*.log "${TARGET}/logs"



