#!/bin/sh

set -eux

make

mkdir -p /tmp/mount-dir

CONTAINER=`./run.py --address 127.0.0.1 --port 12345 --dir /tmp/mount-dir`

docker stop $CONTAINER
docker rm $CONTAINER
