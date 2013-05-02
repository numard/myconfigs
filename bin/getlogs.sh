#!/bin/bash

if [ "$1" == "" ] ; then
    echo "please give me a hostname"
    exit 1
else
    APP="$1"
fi
    
cd ~/Entropy/app_cleanup/logs/
mkdir "$APP" ; cd "$APP"


# doing a 2 step process to avoid getting empty directory tree created on my side
# Static has a directory 
ssh root@${APP} find /content/ \\\( \\\( -type f -a \\\( -iname "*.log" -o -iname "*.log.*" \\\) \\\) -o \\\( -type d -a -name logs \\\) \\\) | while read i ; do 
    rsync -rRavz --progress root@${APP}:${i} .
done

# gotta escape for local AND remote...#$%#$
ssh root@${APP} find /www-cache/ -type f \\\( -iname "*.log" -o -iname "*.log.*" \\\) | while read i ; do
    rsync -rRavz --progress root@${APP}:${i} .
done

