#!/bin/sh


curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-354.0.0-linux-x86_64.tar.gz \
&& gunzip ./google-cloud-sdk-354.0.0-linux-x86_64.tar.gz \
&& tar -xf google-cloud-sdk-354.0.0-linux-x86_64.tar \
&& chmod 777 ./google-cloud-sdk/install.sh

docker build docker -t test_docker --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)

docker run --rm -it -v $PWD:/work -w /work test_docker

# first you must have a service account for the bucket you aim to connect to
# and generate a creential file with
# gcloud iam service-accounts keys create 
