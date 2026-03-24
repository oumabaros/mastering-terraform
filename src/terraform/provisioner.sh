#!/bin/bash
awslocal ec2 create-key-pair --key-name ec2_vm_manager
tflocal plan -target "random_shuffle.az"
tflocal apply -target "random_shuffle.az" -auto-approve

# tflocal plan -target "aws_iam_instance_profile.backend_profile"
# tflocal apply -target "aws_iam_instance_profile.backend_profile" -auto-approve

tflocal plan
tflocal apply -auto-approve

