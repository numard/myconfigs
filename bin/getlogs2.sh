#!/bin/bash
#
# $0 [HOSTNAME] [TYPE]
#
if [ "$1" == "" ] ; then
    echo "please give me a hostname"
    exit 1
else
    HOST="$1"
fi


if [ "$2" == "" ] ; then
    echo "need host type: app or lb"
    exit 1
else
    TYPE="$2"
fi

    
cd ~/Entropy/app_cleanup/logs/
mkdir "$HOST" ; cd "$HOST"

if [ "$TYPE" == "app" ] ; then

    SSHUSER="root"
    # doing a 2 step process to avoid getting empty directory tree created on my side
    # TODO This could be changed to output to a tmp file and do a one rsync pass with include file...
    ssh ${SSHUSER}@${HOST} find /content/ \\\( \\\( -type f -a \\\( -iname "*.log" -o -iname "*.log.*" \\\) \\\) -o \\\( -type d -a -name logs \\\) \\\) | while read i ; do 
        rsync -rRavz --progress ${SSHUSER}@${HOST}:${i} .
    done

    ssh ${SSHUSER}@${HOST} find /www-cache/ -type f \\\( -iname "*.log" -o -iname "*.log.*" \\\) | while read i ; do
        rsync -rRavz --progress ${SSHUSER}@${HOST}:${i} .
    done

elif [ "$TYPE" == "lb" ] ; then
    
    SSHUSER="ubuntu"
    ssh ${SSHUSER}@${HOST}  "sudo chown -R ubuntu: /mnt" 
    ssh ${SSHUSER}@${HOST} find /mnt/ -type f \\\( -iname "*.log" -o -iname "*.log.*" \\\) | while read i ; do
                rsync -rRavz --progress ${SSHUSER}@${HOST}:${i} .
            done

else
    echo "sorry, wrong host type - Only allowed (case sensitive): app lb "
    exit 1
fi