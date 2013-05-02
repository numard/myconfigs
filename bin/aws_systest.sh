#!/bin/bash
# Sets up environment for freelancer main account
## SET IN .bashrc export JAVA_HOME=/usr/local/java/jdk1.7.0_04/
export EC2_HOME=~/bin/ec2-api-tools/
# Beto's own auth info
export EC2_PRIVATE_KEY=~/_1/access_aws/sys-test/beto-systest.iam.pk.pem
export EC2_CERT=~/_1/access_aws/sys-test/beto-systest.iam.cert.pem

# for user beto-systest ( iam role)
export EC2_API_KEY=AKIAJE43AF3L4UXNTDIQ
export EC2_API_SECRET=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

# ensure this points to aws.crentials-SYSTEST
export AWS_CREDENTIAL_FILE=~/.aws-credentials-SYSTEST
