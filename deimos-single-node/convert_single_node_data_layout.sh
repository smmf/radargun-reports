#!/bin/bash

for bench in RW*; do
    newdir="${bench}/reports"

    mkdir -p ${newdir}

    for threads in 01 08 16 24 32 40 48; do
        
        for csv_file in `ls ${bench}/${threads}/reports/*.csv`; do
            
            oldfile=`basename ${csv_file} _1.csv`
            newfile="${oldfile}_${threads}.csv"
            cp ${csv_file} ${newdir}/${newfile}
        done
    done
done
