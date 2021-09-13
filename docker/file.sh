#!/bin/bash

SERVICEACCT=$1
PROJECT=$2
DSM=$3
BBOX=$4



./google-cloud-sdk/install.sh --rc-path ~/.bash_profile -q

PATH="$PATH" && exec bash

source '/work/google-cloud-sdk/path.bash.inc'
source '/work/google-cloud-sdk/completion.bash.inc'

gcloud iam service-accounts keys create /work/key.json --iam-account=$SERVICEACCT@$PROJECT.iam.gserviceaccount.com

{gcloud auth activate-service-account --key-file=key.json} || {
echo "Waiting for key to take hold!" \
&& sleep 30 \
&& echo "Hear any good jokes lately?" \
&& sleep 30 \
&& gcloud auth activate-service-account --key-file=key.json 
}



gcloud config set project 
