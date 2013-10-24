#!/bin/bash

echo "This will delete all files with patterns: *.log *.out *.dat *.pdf *.gp"
echo
echo "Press <ENTER> to continue or Ctrl-c to abort"
echo
read

find . -name \*.log -print0 | xargs -0 rm
find . -name \*.out -print0 | xargs -0 rm
find . -name \*.dat -print0 | xargs -0 rm
find . -name \*.pdf -print0 | xargs -0 rm
find . -name \*.gp -print0 | xargs -0 rm
