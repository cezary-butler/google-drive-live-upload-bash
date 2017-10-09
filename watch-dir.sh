#!/usr/bin/env bash

echo 'Setting up trap for children'
trap 'kill $(jobs -p)' EXIT
DIRECTORY=$1

echo 'Starting directory watch on ' $DIRECTORY

. env.sh

function removePipes {
  rm -f ${FILES} ${SPLIT}
}

removePipes

mkdir -p ${GSYNCD}/pipes

mkfifo ${FILES}

INOTIFY_ARGS="--format %w%f -rme close_write"

if [ $2 ]
  then
  INOTIFY_ARGS="$INOTIFY_ARGS -t $2"
fi

#todo sposob na monitorowanie tylko najnowszych w strukturze po 1 na poziom na pewno bez -r
inotifywait $INOTIFY_ARGS $DIRECTORY  > ${FILES} &

echo 'Initialized inotify'
sleep 1

split -ul 25 --filter="tar --no-seek -cjf - -T - | ${GSYNCD}/gdrive-upload.sh" ${FILES} &

echo 'Split initialized'
sleep 1

echo 'Will wait for children to finish'
wait

echo 'All done!'

removePipes
