#!/bin/sh

set -eux

function setup_user() {
    USER=$@
    PUBKEYS=/external/$USER-pubkeys
    if [ -d $PUBKEYS ]
    then
        mkdir -p /home/$USER/.ssh
        for FILE in `ls $PUBKEYS`
        do
            cat $PUBKEYS/$FILE >> /home/$USER/.ssh/authorized_keys
        done
        chown -R $USER /home/$USER/.ssh
        chgrp -R $USER /home/$USER/.ssh
    fi
}

setup_user owner
setup_user guest

/usr/sbin/sshd -D
