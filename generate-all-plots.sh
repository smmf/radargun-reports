#!/bin/bash

make-all-gnuplot-data.sh

PRODUCTS=`cut -d',' -f1 map-products-to-labels.txt | paste -s -d ' ' -`

for workload in RO-100*; do
    echo "Generating plot for $workload"
    generate-plot.sh $workload $PRODUCTS
done

for workload in RW*-100*-10p; do
    echo "Generating plot for $workload"
    generate-plot.sh $workload $PRODUCTS
done
