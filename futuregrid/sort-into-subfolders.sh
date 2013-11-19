#!/bin/bash

WTP="01 05 10 20"
NE="100 1000 10000"
WP="1"
P="tdmock-g2800ns-p67000ns-c64000ns fflf-tdmock-g2800ns-p67000ns-c64000ns"
NODES=`seq 2 2 12`

for wtp in $WTP; do
    for ne in $NE; do
        for wp in $WP; do
            for p in $P; do
                mkdir -p RW$wtp-$ne-${wp}p/reports
                mkdir -p RW$wtp-$ne-${wp}p/logs
                mv logs-wtp${wtp}_ne${ne}_wp${wp}_${p} RW$wtp-$ne-${wp}p/logs/${p}

                for nodes in $NODES; do
                    mv wtp${wtp}_ne${ne}_wp${wp}_${p}_${nodes}.csv RW$wtp-$ne-${wp}p/reports/${p}_${nodes}.csv
                done
            done
        done
    done
done


for i in ../../*.sh; do
    ln -s $i
done

\rm pull-from-deimos.sh

cp ../../map-products-to-labels.txt .

mkdir plots
