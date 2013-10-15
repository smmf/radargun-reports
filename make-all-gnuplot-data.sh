#!/bin/bash

for workload in RO*-100*; do
    make_gnuplot_data.sh $workload
done

for workload in RW*-100*-10p; do
    make_gnuplot_data.sh $workload
done

for workload in RW*-100*-1p; do
    make_gnuplot_data.sh $workload
done
