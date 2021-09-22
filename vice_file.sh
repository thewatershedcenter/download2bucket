#!/bin/bash

KEYJSON=$1
URLS=$2
BUCKET=$3
BUCKDIR=$4
EPSG=$5
RM=$6
AG=$7

# authorize gcloud account
gcloud auth activate-service-account --key-file $KEYJSON

# make a directory for downloaded las files
LAS=/home/user/work/$BUCKDIR/las
mkdir -p $LAS

# make afunction to handle curling and saveing
curling_func(){
    url=$1
    bkdir=$2
    f="$(echo $url | rev | cut -d"/" -f1 | rev)"
    curl -L -s -o /out/$bkdir/las/$f $url
    #[[ $AG = remove ]]; gsutil cp /out/$BUCKDIR/$f gs://$BUCKET/$BUCKDIR/ && rm /out/$BUCKDIR/$f
}
export -f curling_func

# curl files in || (note the way BUCKDIR is passed is wierd, the function puts it in between  /out and /las)
cat $URLS | parallel --bar curling_func {1} $BUCKDIR

# how many cores have we?
NCORES=$(grep -c ^processor /proc/cpuinfo)

# make an entwine dir
ENTWINE=/home/user/work/$BUCKDIR/entwine
mkdir -p $ENTWINE

entwine build -i $LAS -o $ENTWINE --srs $EPSG -t $NCORES

# copy files to gcloud bucket
gsutil -m cp -r /home/user/work/$BUCKDIR gs://$BUCKET

# if -r or -a flag was set in start remove files or dir
if [[ $RM = remove ]]
then
    rm -r /home/user/work/$BUCKDIR
fi