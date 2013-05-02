#!/bin/bash

D="/home/beto/Pictures/Wallpapers"
N=`expr  $RANDOM % 15`
F=`ls -1 $D/ | head -n $N | tail -n 1`
X=`ps xa|grep /usr/bin/X |grep -v grep | awk '{print $6}'`

DISPLAY=$X /usr/bin/feh --bg-max $D/$F 
