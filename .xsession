#1/bin/bash
xrdb ~/.Xresources

#if [ ! `pulseaudio --check` ] ; then 
#	pulseaudio --daemonize
#fi

~/bin/change_bg.sh
/usr/bin/stalonetray &

xscreensaver -nosplash&
/usr/bin/dropbox start &

/usr/bin/skype &

volti &
/usr/bin/xfce4-clipman &
shutter &

xmonad
