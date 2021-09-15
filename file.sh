#!/bin/bash


KEYJSON=$1
URLS=$2
BUCKET=$3
BUCKDIR=$4
RM=$5
AG=$5

# authorize gcloud account
gcloud auth activate-service-account --key-file $KEYJSON

# make a directory for downloaded files within outpath
mkdir -p /out/$BUCKDIR

# make afunction to handle curling and saveing
curling_func(){
    url=$1
    bkdir=$2
    f="$(echo $url | rev | cut -d"/" -f1 | rev)"
    curl -L -s -o /out/$bkdir/$f $url
    #[[ $AG = remove ]]; gsutil cp /out/$BUCKDIR/$f gs://$BUCKET/$BUCKDIR/ && rm /out/$BUCKDIR/$f
}
export -f curling_func

# curl files in ||
cat $URLS | parallel --bar curling_func {1} $BUCKDIR

# copy files to gcloud bucket
gsutil -m cp -r /out/$BUCKDIR gs://$BUCKET

# if -r or -a flag was set in start remove files or dir
if [[ $RM = remove ]]
then
    rm -r /out/$BUCKDIR
fi
