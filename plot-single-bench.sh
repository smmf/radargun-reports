#!/bin/bash

make_gnuplot_data.sh $1
generate-plot.sh $1 `cut -d',' -f1 map-products-to-labels.txt | paste -s -d ' ' -`
