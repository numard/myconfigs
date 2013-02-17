#1/bin/bash
xrdb ~/.Xresources

#if [ ! `pulseaudio --check` ] ; then 
#	pulseaudio --daemonize
#fi

#reload feh last settings
eval $(cat ~/.fehbg)

/usr/bin/stalonetray &

xscreensaver -nosplash&
/usr/bin/dropbox start &

/usr/bin/skype &

volti &
/usr/bin/xfce4-clipman &
shutter &

xmonad
