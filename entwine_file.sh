#!/bin/bash


KEYJSON=$1
URLS=$2
BUCKET=$3
BUCKDIR=$4
EPSG=$5

# authorize gcloud account
gcloud auth activate-service-account --key-file $KEYJSON

# make a directory for downloaded files within outpath
LAS=/out/$BUCKDIR/las
mkdir -p $LAS

# make a function to handle curling and saveing
curling_func(){
    url=$1
    lasdir=$2
    f="$(echo $url | rev | cut -d"/" -f1 | rev)"
    curl -L -s -o $lasdir/$f $url
}
export -f curling_func

# curl files in ||
cat $URLS | parallel --bar curling_func {1} $LAS

# how many cores have we?
NCORES=$(grep -c ^processor /proc/cpuinfo)

# make an entwine dir
ENTWINE=/out/$BUCKDIR/entwine
mkdir -p $ENTWINE

entwine build -i $LAS -o $ENTWINE -t $NCORES

# copy files to gcloud bucket
gsutil -m cp -r $ENTWINE gs://$BUCKET

