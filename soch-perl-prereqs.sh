#!/usr/bin/env bash

# Runnable's perl is old, and has no non-core modules. It doesn't have cpanminus to install them, either.
# We need LWP::Simple and XML::XPath, which requires expat, which is also not installed.

# Amazon's S3 is not to be trusted, as it frequently returns 403 errors when fetching packages:
sed -i -e 's/us-east-1\.ec2\.//ig' -e 's!ubuntu/!ubuntu!ig' /etc/apt/sources.list

# Remove duplicate entries from the package source list:
sort -u /etc/apt/sources.list -o /etc/apt/sources.list
apt-get update -y -qq

# Install expat libraries:
apt-get -y -qq install libexpat1-dev

# Bootstrap cpanminus:
curl -s -L http://cpanmin.us | perl - App::cpanminus

# Install modules:
cpanm -q LWP::Simple XML::XPath

