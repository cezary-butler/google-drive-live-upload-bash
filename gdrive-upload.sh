#!/usr/bin/env bash
echo gdrive upload
. env.sh

TARGET_FILE=$1

echo "Target file:" ${TARGET_FILE}

if [ -z "${TARGET_FILE}" ]
then
  TARGET_FILE="ZM$(date -Iseconds).tar.bz2"
fi
echo "Target file:" ${TARGET_FILE}
gdrive upload - --no-progress -p ${GDIVE_TARGET} ${TARGET_FILE}
