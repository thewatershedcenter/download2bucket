#!/bin/bash

KEYJSON=$1
URLS=$2
BUCKET=$3
BUCKDIR=$5
EPSG=$4

# debugging echos
echo "$epsg = EPSG"
TXT=$(realpath $URLS)
P="${TXT%/*}/"
echo $P

# authorize gcloud account
gcloud auth activate-service-account --key-file $KEYJSON

# make a directory for downloaded las files
echo '---------------------making las dir ---------------------'
LAS=/root/work/$BUCKDIR/las
mkdir -p $LAS

# make afunction to handle curling and saveing
curling_func(){
    url=$1
    lasdir=$2
    f="$(echo $url | rev | cut -d"/" -f1 | rev)"
    curl -L -s -o $lasdir/$f $url
}
export -f curling_func

echo '---------------------start curl ---------------------'
# curl files in || 
cat $URLS | parallel --bar curling_func {1} $LAS

echo '---------------------end curl ---------------------'
# how many cores have we?
NCORES=$(grep -c ^processor /proc/cpuinfo)

# make an entwine dir
ENTWINE=/root/work/$BUCKDIR/entwine
mkdir -p $ENTWINE

echo  { \"reprojection\": { \"out\": \"$srs\" } } >> /root/work/reproj.json

echo '---------------------do entwine ---------------------'
entwine build -i $LAS -o $ENTWINE  -t $NCORES # --reprojection reproj.json 

echo '---------------------gsutil ---------------------'
# copy files to gcloud bucket
gsutil -m cp -r $ENTWINE gs://$BUCKET



