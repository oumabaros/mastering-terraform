#!/bin/bash
echo "Hey There!"

cat << EOF | sudo tee -a /etc/apt/preferences.d/dotnet.pref
Package: *
Pin: origin "packages.microsoft.com"
Pin-Priority: 1001
EOF
ls /etc/apt/preferences.d