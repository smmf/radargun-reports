#!/bin/bash

FILE=$1

FIRST=`grep -n ContinueStressTestStage $FILE | head -n 1  | cut -d: -f1`
LAST=`grep -n ContinueStressTestStage $FILE | tail -n 1  | cut -d: -f1`
sed -n "${FIRST},${LAST}p" ${FILE}
