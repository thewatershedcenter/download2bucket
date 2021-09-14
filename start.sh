#!/bin/sh

RM=do_not_remove
AG=do_not_remove

while getopts "hrak:u:o:b:d:" flag; do
case "$flag" in
    h)  
        echo "SYNOPSIS"  
        echo "     ./start [options] -k key_file -u list_of_urls -o output_dir -b bucket -d bucket_dir "
        echo "DESCRIPTION"
        echo "     Downloads files from list"
        echo "     Copies them to gcloud bucket"
        echo "        "
        echo "     options:"
        echo "        "
        echo "        -h - display help"
        echo "        "
        echo "        -r - if set local files will be deleted after being"
        echo "        colpied to the bucket"
        echo "        "
        echo "        -a - if set each file will be delected as soon as it is"
        echo "        copied to the bucket. Intended for use with a large"
        echo "        number of files that may require more disk space"
        echo "        than available on local machine. Probably slower."
        echo "        "        
        echo "     arguments:"
        echo "        "
        echo "        -k [key_file] - gcloud service account key json file, see"
        echo "        https://cloud.google.com/docs/authentication/getting-started,"
        echo "        or use gcloud iam service-accounts keys create"
        echo "        " 
        echo "        -u [list_of_urls] - list of urls to be downloaded, one per line."
        echo "        "
        echo "        -o [output_dir] - local directory that will be mounted by the"
        echo "        container and used to store downloaded files"
        echo "        "
        echo "        -b [bucket] - name of gcloud bucket to which files should be"
        echo "        transfered"
        echo "        "
        echo "        -d [bucket_dir] - name of directory which will be created (if"
        echo "        it does not exist)"
        echo "        in bucket to store files. (It is my understanding that google"
        echo "        buckets do not actually have directories, they are flat,"
        echo "        but the files will appear in the bucket with names"
        echo "        as though they were in directories)"
        exit 0
        ;;
    r)  RM=remove;;
    a)  echo "-a is not yet implemented"
        exit 0
        AG=remove
        RM=remove;;
    k)  KEYJSON=$OPTARG;;
    u)  URLS=$OPTARG;;
    o)  OUTDIR=$OPTARG;;    
    b)  BUCKET=$OPTARG;;
    d)  BUCKDIR=$OPTARG;;
esac
done

docker build docker -t test_docker --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)

docker run --rm -it -v $PWD:/work -v $OUTDIR:/out -w /work test_docker $KEYJSON $URLS $BUCKET $BUCKDIR $RM $AG

# first you must have a service account for the bucket you aim to connect to
# and generate a credential file with
# gcloud iam service-accounts keys create 

# ./start.sh monument2_key.json small.txt /media/data/Downloads/ monument_bucket Carr_
# ./start.sh -r -k monument2_key.json -u small.txt -o /media/data/Downloads/ -b monument_bucket -d Carr_ 
# ./start.sh -r -k monument2_key.json -u carr_downloadlist_lidar.txt -o /media/data/Downloads/ -b monument_bucket -d carr_lidar 