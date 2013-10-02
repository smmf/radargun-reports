#!/bin/bash

# $1: dir containing reports/*.csv files
# $2: column to compute (sum, average

#N1,sum,avg
#N2,sum,avg 

TARGET_DIR="${1}/reports"

PRODUCTS=$(for i in `ls ${TARGET_DIR}/*.csv`; do 
    BASE=`basename $i`
    echo ${BASE%%_[0-9]*.csv}
done | sort -u)

# echo $PRODUCTS


for product in $PRODUCTS; do
    DAT=`echo ${TARGET_DIR}/${product}.dat`
    echo "${DAT}"

    echo "# NODE,SUM,AVG" > ${DAT}
    
    for file in `ls ${TARGET_DIR}/${product}_*.csv`; do
#        echo "file: ${file}"
        # X=${file%%_[0-9]*.cs}

        # DEST_BASE=`basename ${file} .csv`
        # DEST=`echo ${DEST_BASE}.dat`

        short_name=`basename ${file}`
        NODE=${short_name##${product}_}
        NODE=${NODE%%.csv}
#        echo "node: "$NODE

  # coluna #9 tem TRNSACTIONS_PER_SEC

        SUM=`awk -F ',' '{ x = x + $9 } END { print x }' ${file}`
        #AVG=`echo "scale=2; $SUM / $NODE" | bc`
        AVG=`echo "$SUM,$NODE" | awk -F ',' '{ x = $1 / $2 } END { print x }'`
        echo ${NODE}","${SUM}","${AVG} >> ${DAT}
        sort -g ${DAT} > /tmp/lixo
        mv /tmp/lixo ${DAT}
    done
done



