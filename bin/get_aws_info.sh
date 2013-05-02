#!/bin/bash
D=/home/beto/Entropy/aws_info
FIns=$D/ec2-instances/instances-`date +%Y%m%d-%H%M`
FSec=$D/sec-groups/secgroups-`date +%Y%m%d-%H%M`
LIns=$D/ec2-instances/instances-latest
LSec=$D/sec-groups/secgroups-latest

REGIONS="us-east-1 us-west-1 us-west-2 ap-southeast-1 eu-west-1"
export JAVA_HOME=/opt/jdk/jre

source /home/beto/.bashrc
source /home/beto/bin/aws_main.sh

mkdir -p $D/ec2-instances $D/sec-groups

for r in $REGIONS ; do 
    ec2-describe-instances --region $r  >> $FIns
    ec2-describe-group --region $r >> $FSec
done

rm $LIns
ln -s $FIns $LIns

rm $LSec
ln -s $FSec $LSec

rsync -ra $D /home/beto/Dropbox/work/Freelancer/

( cd ~/dev/admin/ec2 ; /home/beto/dev/env.aws/bin/python ~/dev/admin/ec2/route53_dump.py  -o ~/dev/prodconfigs/dns/route53 )
