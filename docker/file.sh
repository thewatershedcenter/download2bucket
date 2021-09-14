#!/bin/bash

KEYJSON=$1
URLS=$2
#PROJECT=$2
#DSM=$3
#BBOX=$4



#gcloud auth activate-service-account --key-file $KEYJSON
mkdir -p /out/files

curling_func(){
    url=$1
    f="$(echo $url | rev | cut -d"/" -f1 | rev)"
    curl -L -s -o /out/files/$f $url
}
export -f curling_func

cat $URLS | parallel --bar curling_func {1}

gsutil -m cp -r /out/files gs://monument_bucket



