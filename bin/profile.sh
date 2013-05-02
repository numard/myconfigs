#!/bin/bash

# Slightly modified from
# http://poormansprofiler.org/

# profile.sh PROC_NAME nsamples=1 sleeptime=0

if [ "$2" != "" ] ; then
    nsamples=$2
else
    nsamples=1
fi

if [ "$3" != "" ] ; then
    sleeptime=$3
else
    sleeptime=0
fi

pid=$(pidof $1)

for x in $(seq 1 $nsamples)
  do
    sudo gdb -ex "set pagination 0" -ex "thread apply all bt" -batch -p $pid
    sleep $sleeptime
  done | \
awk '
  BEGIN { s = ""; } 
  /^Thread/ { print s; s = ""; } 
  /^\#/ { if (s != "" ) { s = s "," $4} else { s = $4 } } 
  END { print s }' | \
sort | uniq -c | sort -r -n -k 1,1
