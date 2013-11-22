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


