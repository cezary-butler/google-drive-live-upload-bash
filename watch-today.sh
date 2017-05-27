#!/usr/bin/env bash
echo Now is $(date)
CAMERA_ID=2
TODAY_PATH=$(date '+%y/%m/%d')
WATCH_PATH=/var/cache/zoneminder/events/$CAMERA_ID/$TODAY_PATH
echo CAMERA_ID = $CAMERA_ID
echo TODAY_PATH = $TODAY_PATH

if [ ! -d ${WATCH_PATH} ]; then
  echo "Directory " ${WATCH_PATH} "not found."
  echo "Trying to create"
  mkdir -p ${WATCH_PATH}
fi

/home/gsync/watch-mp2.sh ${WATCH_PATH}
