#!/bin/bash
cd backend
packer init .
PACKER_LOG=1 packer build .
cd ../frontend
packer init .
PACKER_LOG=1 packer build .
cd ../
