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
# set terminal pdfcairo font 'DejaVu Sans,9' rounded dashed mono enhanced
set terminal pdfcairo font 'DejaVu Sans,9' rounded dashed enhanced
#set terminal pdfcairo rounded dashed enhanced
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
# set style line 1 lt 1 lc -1 pt 4 # --- ISPN
# set style line 2 lt 1 lc  1 pt 5 # --- ISPN + LB
# set style line 3 lt 4 lc  2 pt 5 # --- ISPN + LF
# set style line 4 lt 4 lc 4 pt 14 # --- Hazelcast
# set style line 5 lt 1 lc  1 pt 9 # --- Hazelcast + LB
# set style line 6 lt 4 lc  2 pt 9 # --- Hazelcast + LF
#
# set style line 10 lt 1 lc -1 pt 8 # --- hazel
# set style line 11 lt 4 lc -1 pt 8 # --- hazel + lb
# set style line 12 lt 3 lc -1 pt 9 # --- hazel + lf
#
# set style line 20 lt 1 lc 1 pt 10 # --- ispn53
# set style line 21 lt 4 lc 1 pt 10 # --- ispn53 + lb
# set style line 22 lt 3 lc 1 pt 11 # --- ispn53 + lf
#
# set style line 30 lt 1 lc 2 pt 12 # --- ehcache
# set style line 31 lt 4 lc 2 pt 12 # --- ehcache + lb
# set style line 32 lt 3 lc 2 pt 13 # --- ehcache + lf
#
# set style line 40 lt 1 lc 3 pt 6 # --- mock
# set style line 41 lt 4 lc 3 pt 6 # --- mock + lb
# set style line 42 lt 3 lc 3 pt 7 # --- mock + lf

set style line 10 lt 1 lc 3 pt 8 # --- hazel
set style line 11 lt 4 lc 4 pt 9 # --- hazel + lb
set style line 12 lt 2 lc -1 pt 8 # --- hazel + lf

set style line 20 lt 1 lc 3 pt 10 # --- ispn53
set style line 21 lt 4 lc 4 pt 11 # --- ispn53 + lb
set style line 22 lt 2 lc -1 pt 10 # --- ispn53 + lf

set style line 30 lt 1 lc 3 pt 12 # --- ehcache
set style line 31 lt 4 lc 4 pt 13 # --- ehcache + lb
set style line 32 lt 2 lc -1 pt 12 # --- ehcache + lf

set style line 40 lt 1 lc 3 pt 6 # --- mock
set style line 41 lt 4 lc 4 pt 7 # --- mock + lb
set style line 42 lt 2 lc -1 pt 6 # --- mock + lf

set key left top Right
#set key at 10,50
#set key samplen 2.5 spacing 2.0


#set xtics (1,4,8,12,16,20,24,28,32,36,40,44,48) font "DejaVu Sans,17" offset 0, graph -0.02
set xtics font "DejaVu Sans,10" offset 0, graph -0.02
#set xrange [1:48]
set xlabel "Threads" font "DejaVu Sans,10" offset 0, graph -0.03

set ytics font "DejaVu Sans,10"
#set yrange [:]
set ylabel "Throughput (1000 txs/sec)" font "DejaVu Sans,10" offset -3

#unset key

set title "${WORKLOAD}" font "DejaVu Sans,12"

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
