#!/bin/bash

## function for finding a file's absolute path
SCRIPT_DIR=
function absname() {
  pushd `dirname "$1"` > /dev/null
  SCRIPT_DIR=`pwd`
  popd > /dev/null
  return
}

absname "$0"

. ${SCRIPT_DIR}/configs.sh


# WTP="01 05 10 20"
# NE="100 1000 10000"
# WP="1"
# # P="tdmock-g2800ns-p67000ns-c64000ns fflf-tdmock-g2800ns-p67000ns-c64000ns"
# P="ispn53-repl-sync-rc fflf-ispn53-repl-sync-rc"
# NODES=`seq 2 2 12`

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
