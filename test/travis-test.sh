#!/bin/sh

set -eux

ssh-keygen -q -t rsa -f ~/.ssh/travis_rsa -N ""

make

mkdir -p /tmp/mount-dir
echo "hello world" > /tmp/mount-dir/file

CONTAINER=`./run.py --address 127.0.0.1 --port 12345 \
    --owner-pubkey ~/.ssh/travis_rsa.pub \
    --guest-pubkey ~/.ssh/travis_rsa.pub \
    --dir /tmp/mount-dir`

sleep 5

ssh -i ~/.ssh/travis_rsa -p 12345 -o StrictHostKeyChecking=no \
    owner@127.0.0.1 "cat /external/mount-dir/file"
ssh -i ~/.ssh/travis_rsa -p 12345 -o StrictHostKeyChecking=no \
    guest@127.0.0.1 "cat /external/mount-dir/file"

docker stop $CONTAINER
docker rm $CONTAINER
