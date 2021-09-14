#!/bin/sh

KEYJSON=$1
URLS=$2
OUTDIR=$3

docker build docker -t test_docker --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)

docker run --rm -it -v $PWD:/work -v $OUTDIR:/out -w /work test_docker $KEYJSON $URLS

# first you must have a service account for the bucket you aim to connect to
# and generate a creential file with
# gcloud iam service-accounts keys create 
# ./start.sh monument2_key.json small.txt /media/data/Downloads/

