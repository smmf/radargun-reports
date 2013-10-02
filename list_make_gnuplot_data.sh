#!/bin/bash

for i in `make_gnuplot_data.sh $1`; do
    echo "=== $i"
    cat $i
done