#!/bin/sh

RM=persist
PARAMS=""
while (( "$#" )); do
    case "$1" in
        -h | --help)
            echo "SYNOPSIS"  
            echo "     ./start [key_file] [list_of_urls] [output_dir] [bucket] [bucket_dir] "
            echo "DESCRIPTION"
            echo "     Downloads files from list"
            echo "     Copies them to gcloud bucket"
            echo "        "
            echo "     flags:"
            echo "        - h - display help"
            echo "        "
            echo "        - r - if set local files will be deleted after being colpied to the bucket"
            echo "        "
            echo "     positional arguments:"
            echo "        [key_file] - gcloud service account key json file, see"
            echo "        https://cloud.google.com/docs/authentication/getting-started"

            echo "        [list_of_urls] - list of urls to be downloaded, one per line."
            echo "        "
            echo "        [output_dir] - local directory that will be mounted by the"
            echo "        container and used to store downloaded files"
            echo "        [bucket] - name of gcloud bucket to which files should be transfered"
            echo "        "
            echo "        [bucket_dir] - name of directory which will be created in bucket to"
            echo "        store files. (It is my understanding that google buckets do not"
            echo "        actually have directories, they are flat, but the files will appear"
            echo "        in the bucket with names as though they were in directories)"
            shift
            ;;
        -r | --remove)
            RM=remove
            shift
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
    esac
done




KEYJSON=$1
URLS=$2
OUTDIR=$3
BUCKET=$4
BUCKDIR=$5


docker build docker -t test_docker --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)

docker run --rm -it -v $PWD:/work -v $OUTDIR:/out -w /work test_docker $KEYJSON $URLS $BUCKET $BUCKDIR $RM

# first you must have a service account for the bucket you aim to connect to
# and generate a creential file with
# gcloud iam service-accounts keys create 

# ./start.sh monument2_key.json small.txt /media/data/Downloads/ monument_bucket  Carr
