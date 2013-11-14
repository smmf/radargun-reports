#!/bin/bash

for i in `ls *.out | cut -d- -f3 | cut -d\. -f1`; do ../../crop.sh stdout_slave_deimos-esw-$i.out > $i.out; done

\rm stdout_slave_deimos-esw-*

for i in *.out; do grep {C} $i | cut -d[ -f1 > $i.c;  done

for i in *.out.c; do csv-average.sh 0 $i K0 V1 V2 V3 V4 V5 V6 V7 V8 > `basename $i .out.c`.stats; done