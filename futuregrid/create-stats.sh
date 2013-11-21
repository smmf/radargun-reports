#!/bin/bash

WTP="01 05 10 20"
NE="10000"
WP="1"
P="fflf-tdmock-g2800ns-p67000ns-c64000ns"
NODES=`seq 2 2 12`

for wtp in $WTP; do
    for ne in $NE; do
        for wp in $WP; do
            for p in $P; do
                # RW$wtp-$ne-${wp}p/reports
                # LOGS_DIR=RW$wtp-$ne-${wp}p/logs

                for nodes in $NODES; do
                    SINGLE_NODE_DIR=RW$wtp-$ne-${wp}p/logs/${p}/${nodes}nodes
                    echo "Processing $SINGLE_NODE_DIR"

                    (cd $SINGLE_NODE_DIR; ../../../../../process-futuregrid.sh)
                done
            done
        done
    done
done


# for i in ../../*.sh; do
#     ln -s $i
# done

# \rm pull-from-deimos.sh

# cp ../../map-products-to-labels.txt .

# mkdir plots
