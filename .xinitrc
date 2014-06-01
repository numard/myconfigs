#!/bin/bash

F=/tmp/beto.log
date >> $F

xrdb ~/.Xresources

eval $(gpg-agent --daemon)

# Enable zapping (C-A-<Bksp> kills X)
setxkbmap -option terminate:ctrl_alt_bksp

# Use XToolkit in java applications
export AWT_TOOLKIT=XToolkit

#if [ ! `pulseaudio --check` ] ; then 
#	pulseaudio --daemonize
#fi

echo 'before change_bg' >> $F 
~/bin/change_bg.sh 

sleep 1
echo 'before xscreensaver' >>$F
xscreensaver -nosplash  &

/usr/bin/dropbox start  &
/usr/bin/synapse --startup &

# notification thingy
/usr/bin/dunst &
# exec/usr/bin/skype 

echo 'b4 volti' >> $F
volti &
/usr/bin/xfce4-clipman &
#exec shutter

# Kb repeat rate : 250ms wait, then 50 cps
/usr/bin/xset r rate 250 50
# pointer acceleration
/usr/bin/xset m 4/1 3


/usr/bin/i3 -V >> ~/.xsession-errors
