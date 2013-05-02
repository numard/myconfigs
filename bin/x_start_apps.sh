#!/bin/bash

eval $( cat ~/.fehbg )

xrdb ~/.Xresources

/usr/bin/shutter --min_at_startup &
