# google-drive-live-upload-bash

##What it does
Script uses inotify to start processing every file as soon as it has been closed. 
Files are being processed in batches of n files.
Each batch is started being processed as soon as the first file appears.
Processing pipeline consist's of taring and gzipping files and uploading them straight to google drive.

##Possible application
Script can be used to apply any kind of proccesing to files as soon as they appear. It can be also used (with little modification) to upload files to services other than google drive (as long as command line utility is available).

##Problem to solve
My home surveilance system based on zoneminder detects movent and saves video frames on disk. But in case of break in, perpetrator can find and destroy/steal hardware which is used for storing surveilance material.
In order to preserve surveilance material it has to be uploaded to some remote location ASAP.
I have tried to use gdrive command line utlity directly (sync command), but unfortunately it works to slow (probably because of trying to detect not only new files, but also changes in ones already present). Other command from the same utility, upload is fast enough and the files can apear on on google drive almost immediately.
In the case of this script, google drive is used as remote storage.

##Configuration
To configure gdrive utility please refer to it's documentation.
Other configuration options to be externalized.

#Contents
watch.sh - main script. It takes single argument which is single directory to be watched for changes (close_write - event).
watch-today.sh - scritp which can find today's directory in zoneminder events directory. It uses watch.sh to watch this directory for changes. The reason for this script to exist is that it largely reduces inotify startup time, due to much smaller number of files to watch. If the directory not yet exists, it will be created. 
cron.d/gsync-watch - cron file that causes restart each day - it is needed because zoneminder files from single day are being watched
systemd/system/gsync-watch.service - simple systemd service configuration


