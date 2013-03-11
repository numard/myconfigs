#!/bin/bash

F=/tmp/beto.log
date >> $F 

xrdb ~/.Xresources


#if [ ! `pulseaudio --check` ] ; then 
#	pulseaudio --daemonize
#fi

echo 'before change_bg' >> $F 
~/bin/change_bg.sh 

echo 'b4 stalonetray' >> $F
/usr/bin/stalonetray &

sleep 1
echo 'before xscreensaver' >>$F
xscreensaver -nosplash  &

/usr/bin/dropbox start  &
/usr/bin/synapse --startup &

# exec/usr/bin/skype 

echo 'b4 volti' >> $F
volti &
/usr/bin/xfce4-clipman &
#exec shutter

xmonad
