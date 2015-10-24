#! /bin/bash

#pushd debian-base
#echo "Installing debian/base ..."
#docker build --rm -t debian/base .
#popd

pushd debian-openjdk
echo "Installing debian/openjdk:7 ..."
docker build --rm -t debian/openjdk:7 .
popd

pushd debian-hadoop
echo "Installing debian/hadoop:2.7.1 ..."
docker build --rm -t debian/hadoop:2.7.1 .
popd
