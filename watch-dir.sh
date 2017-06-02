#!/usr/bin/env bash

echo 'Setting up trap for children'
trap 'kill $(jobs -p)' EXIT
DIRECTORY=$1

echo 'Starting directory watch on ' $DIRECTORY

rm -f /home/gsync/pipes/files
rm -f /home/gsync/pipes/split
mkfifo /home/gsync/pipes/files
mkfifo /home/gsync/pipes/split

INOTIFY_ARGS="--format '%w%f' -rme close_write"

if [ $2 ]
  then
  INOTIFY_ARGS="$INOTIFY_ARGS -t $2"
fi

#todo sposob na monitorowanie tylko najnowszych w strukturze po 1 na poziom na pewno bez -r
inotifywait $INOTIFY_ARGS $DIRECTORY  > /home/gsync/pipes/files &

echo 'Initialized inotify'
sleep 1

cat /home/gsync/pipes/files | tee /home/gsync/pipes/split  &

echo 'Stream redirected for split'

split -ul 25 --filter='tar --no-seek -cjf - -T - | gdrive upload - --no-progress -p 0B3lkE4i92Vu6bTEzeGVkd19qRDQ "ZM$(date -Iseconds).tar.bz2"' /home/gsync/pipes/split &

echo 'Split initialized'
sleep 1


echo 'Will wait for children to finish'
wait

echo 'All done!'

rm -f /home/gsync/pipes/files
rm -f /home/gsync/pipes/split
