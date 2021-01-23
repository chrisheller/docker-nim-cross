#!/bin/sh

# delete if it exists so we know that download actually worked
if [ -f tmp_sftp_readme.txt ]; then
  rm tmp_sftp_readme.txt
fi

IMAGE_ID=$(docker build . -q)
docker run -v $(pwd)/.:/usr/local/src "${IMAGE_ID}" nim c -r test_sftp.nim

cat tmp_sftp_readme.txt
