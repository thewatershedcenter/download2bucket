# download2bucket
Containerized utility for downloading files from a list of urls and moving them to a bucket.  currenlty only support gcloud buckets.

## Usage ##
After pulling, enter the download2bucket directory

```./start [options] -k key_file -u list_of_urls -o output_dir -b bucket -d bucket_dir```

where:
```key_file``` is your gcloud service account key json file, see https://cloud.google.com/docs/authentication/getting-started, or use gcloud iam service-accounts keys create.

```list_of_urls``` is the list of urls to be downloaded, one per line.

```output_dir``` is the local directory that will be mounted by the container and used to store downloaded files

```bucket``` is the name of gcloud bucket to which files should be transfered

```bucket_dir``` is the name of the directory which will be created (if it does not exist) in the bucket to store files. (It is my understanding that google buckets do not actually have directories, they are flat, but the files will appear in the bucket with names as though they were in directories)

Options:
```-h``` displays help.

```-r``` removes local files after copying to bucket.

```-a``` (not yet implemented) removes each local file immediately upon copying to bucket> Intended for use in moving large numbers of files that may exceed local storage.  Probably slower.

## TODO: ##
Add Azure and AWS support, implemtn the -a flag.