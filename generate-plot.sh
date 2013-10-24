#!/bin/bash

# $1: dir containing reports/*.dat files
# $2: products to use

WORKLOAD="${1}"
TARGET_DIR="${1}/reports"
shift

PROD_SPEC="$@"
if [ x"$PROD_SPEC" == x"" ]; then
    PROD_SPEC=`cut -d',' -f1 map-products-to-labels.txt | paste -s -d ' ' -`
fi

PRODUCTS=$(for product in $PROD_SPEC; do
    if [ -a "${TARGET_DIR}/${product}.dat" ]; then
        echo "$product"
    fi
done)

#echo $PRODUCTS


plotfile="${TARGET_DIR}/plot.gp"

cat > "${plotfile}" <<EOF
reset

#set terminal svg fname 'DejaVu Sans' fsize '9' rounded dashed
set terminal pdfcairo font 'DejaVu Sans,9' rounded dashed
#set terminal pdf font rounded dashed
set output 'plot.pdf'
set datafile separator ","

# define axis
# remove border on top and right and set color to gray
set style line 11 lc rgb '#000000' lt 1
set border 3 back ls 11 lw 3
set tics out nomirror

# define grid
# set style line 12 lc rgb '#808080' lt 0 lw 1
# set grid back ls 12

# color definitions
#set style line 1 lc rgb '#d80073' lw 2.5 ps 2 # --- ISPN
#set style line 2 lc rgb '#a20025' lw 2.5 ps 2 # --- ISPN + LB
set style line 1 lt 1 lc -1 pt 4 # --- ISPN
set style line 2 lt 1 lc  1 pt 5 # --- ISPN + LB
set style line 3 lt 4 lc  2 pt 5 # --- ISPN + LF
set style line 4 lt 1 lc -1 pt 8 # --- Hazelcast
set style line 5 lt 1 lc  1 pt 9 # --- Hazelcast + LB
set style line 6 lt 4 lc  2 pt 9 # --- Hazelcast + LF

#set xtics (1,4,8,12,16,20,24,28,32,36,40,44,48) font "DejaVu Sans,17" offset 0, graph -0.02
set xtics font "DejaVu Sans,14" offset 0, graph -0.02
#set xrange [1:48]
set xlabel "# Nodes" font "DejaVu Sans,17" offset 0, graph -0.03

set ytics font "DejaVu Sans,14"
#set yrange [:]
set ylabel "Throughput (1000 txs/sec)" font "DejaVu Sans,17" offset -3

#unset key

set title "${WORKLOAD}" font "DejaVu Sans,21"

plot \\
EOF

SEPARATOR="\\"
for product in $PRODUCTS; do

    echo "$SEPARATOR" >> ${plotfile}
    LABEL=`grep "^${product}," map-products-to-labels.txt | cut -d',' -f2`
    LINESTYLE=`grep "^${product}," map-products-to-labels.txt | cut -d',' -f3`
    echo -n "     '${product}.dat'	        u 1:(\$2/1000) t '${LABEL}'	     w lp ls ${LINESTYLE}" >> ${plotfile}
    SEPARATOR=", \\"
done

echo "" >> ${plotfile}

(cd ${TARGET_DIR}; gnuplot plot.gp)

cp ${TARGET_DIR}/plot.pdf plots/${WORKLOAD}.pdf
