#!/bin/bash
I=`/usr/bin/acpitool -B|head -n 2|tail -n 1| cut -d, -f 2-`
echo Bat0 $I
