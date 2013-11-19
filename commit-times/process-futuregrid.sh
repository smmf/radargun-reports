#!/bin/bash

for i in `ls *.out | awk -F'smf' '{print $2}' | cut -d\. -f1`; do ../../crop.sh stdout_slave_smf$i.out > $i.out.b; done

#\rm stdout_slave_smf*

for i in *.out.b; do grep {C} $i | cut -d[ -f1 > $i.c;  done

for i in *.out.b.c; do csv-average.sh 0 $i K0 V1 V2 V3 V4 V5 V6 V7 V8 > `basename $i .out.b.c`.stats; done