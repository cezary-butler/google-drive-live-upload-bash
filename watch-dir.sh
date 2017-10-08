#!/usr/bin/env bash

echo 'Setting up trap for children'
trap 'kill $(jobs -p)' EXIT
DIRECTORY=$1

echo 'Starting directory watch on ' $DIRECTORY

PWD=$(pwd)
GSYNCD=${PWD}/.gsync

mkdir -p ${GSYNCD}/pipes
FILES=${GSYNCD}/pipes/files
SPLIT=${GSYNCD}/pipes/split
rm -f ${FILES} ${SPLIT}
mkfifo ${FILES}
mkfifo ${SPLIT}

INOTIFY_ARGS="--format '%w%f' -rme close_write"

if [ $2 ]
  then
  INOTIFY_ARGS="$INOTIFY_ARGS -t $2"
fi

#todo sposob na monitorowanie tylko najnowszych w strukturze po 1 na poziom na pewno bez -r
inotifywait $INOTIFY_ARGS $DIRECTORY  > ${FILES} &

echo 'Initialized inotify'
sleep 1

#cat ${FILES} | tee ${SPLIT}  &
cat ${FILES} > ${SPLIT}  &

#cat ${SPLIT} &

echo 'Stream redirected for split'

function tar-live {
  tar --no-seek -cjf - -T -
}

GDIVE_TARGET='0B3lkE4i92Vu6bTEzeGVkd19qRDQ'

function gdrive-upload {
  gdrive upload - --no-progress -p ${GDIVE_TARGET} "ZM$(date -Iseconds).tar.bz2"
}

#split -ul 25 --filter='tar-live | gdrive-upload' ${SPLIT} &

split -ul 2  --filter=stat ${SPLIT} &

echo 'Split initialized'
sleep 1


echo 'Will wait for children to finish'
wait

echo 'All done!'

rm -f ${FILES} ${SPLIT}
