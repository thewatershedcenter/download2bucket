#!/bin/bash


KEYJSON=$1
URLS=$2
BUCKET=$3
BUCKDIR=$4
RM=$5

# authorize gcloud account
gcloud auth activate-service-account --key-file $KEYJSON

# make a directory for downloaded files within outpath
mkdir -p /out/BUCKDIR

# make afunction to handle curling and saveing
curling_func(){
    url=$1
    f="$(echo $url | rev | cut -d"/" -f1 | rev)"
    curl -L -s -o /out/BUCKDIR/$f $url
}
export -f curling_func

# curl files in ||
cat $URLS | parallel --bar curling_func {1}

# copy files to gcloud bucket
gsutil -m cp -r /out/BUCKDIR gs://$BUCKET

# if -r flag wat set in start remove files
[[ $RM = remove ]]; rm -r /out/BUCKDIR

