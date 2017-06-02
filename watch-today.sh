#!/usr/bin/env bash
echo Now is $(date)
CAMERA_ID=$1
TODAY_PATH=$(date '+%y/%m/%d')
BASE_PATH=/var/cache/zoneminder/events
WATCH_PATH=$BASE_PATH/$CAMERA_ID/$TODAY_PATH
DAY_SECONDS=86400

echo CAMERA_ID = $CAMERA_ID
echo TODAY_PATH = $TODAY_PATH

if [ ! -d $BASE_PATH ]; then
  echo "base directory $BASE_PATH does not exists"
  exit 1
fi

function waitForDir {
  echo "Waiting for dir $1"
  while [ ! -d $1 ]; do
    inotifywait -e create $(dirname $1) -t $DAY_SECONDS
  done
}

WORK_PATH=$BASE_PATH/$CAMERA_ID

waitForDir $WORK_PATH

WORK_PATH=$WORK_PATH/$(date '+%y')

waitForDir $WORK_PATH

WORK_PATH=$WORK_PATH/$(date '+%m')

waitForDir $WORK_PATH

if [ ! -d ${WATCH_PATH} ]; then
  echo "Directory " ${WATCH_PATH} "not found."
  waitForDir ${WATCH_PATH} 
  echo "Directory appeared "
fi

/home/gsync/watch-mp2.sh ${WATCH_PATH}
