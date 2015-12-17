#!/usr/bin/env python

"""
Helper script for launching a basic developer environment in a docker
container.
"""

import argparse
import os
import shutil
import subprocess
import sys
import uuid


CONTAINER = "%s/devenv" % os.getenv("USER")
DEFAULT_ADDRESS = '127.0.0.1'
DEFAULT_PORT = 12345
PUBKEY_MOUNT_ROOT = "/tmp/devenv"


def make_mount_dir(identifier, suffix):
    """
    Make a temporary directory and return the path.
    """
    mount_dir = os.path.join(PUBKEY_MOUNT_ROOT, "%s-%s" % (identifier, suffix))
    try:
        os.makedirs(mount_dir)
    except OSError:
        pass
    return mount_dir


def copy_pubkeys(mount_dir, pubkeys):
    """
    Copy all the specified public keys into the specified directory.
    """
    for pubkey in pubkeys:
        pubkey_name = os.path.basename(pubkey)
        shutil.copyfile(pubkey, os.path.join(mount_dir, pubkey_name))


def main():
    """
    Main entry point.
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('--address', default=DEFAULT_ADDRESS,
                        help='Host address on which the container will listen')
    parser.add_argument('--port', default=DEFAULT_PORT, type=int,
                        help='Host port which will be forwarded to the '
                             'container\'s listening port')
    parser.add_argument('-d', '--dir', action='append',
                        help='Local dir to mount in the '
                        'image. Will be mounted at /external/<dirname>')
    parser.add_argument('--owner-pubkey', action='append',
                        help='Public key to install in the owner user\'s '
                        'authorized_keys')
    parser.add_argument('--guest-pubkey', action='append',
                        help='Public key to install in the guest user\'s '
                        'authorized_keys')

    args = parser.parse_args(sys.argv[1:])
    docker_args = [
        "docker", "run", "-d", "--name", "devenv-container-%d" % args.port,
        "-p", "%s:%d:22" % (args.address, args.port)
        ]
    # Set up mount directories.
    if args.dir:
        for localdir in args.dir:
            if not os.path.isdir(localdir):
                print "Local directory argument is not a directory!"
                sys.exit(1)
            ext_path = os.path.abspath(localdir)
            int_path = os.path.basename(ext_path)
            docker_args += ["-v", "%s:/external/%s:ro" % (ext_path, int_path)]
    path_identifier = str(uuid.uuid4())
    # Install public keys for the owner user.
    if args.owner_pubkey:
        mount_dir = make_mount_dir(path_identifier, "owner-pubkeys")
        copy_pubkeys(mount_dir, args.owner_pubkey)
        docker_args += ["-v", "%s:/external/owner-pubkeys" % mount_dir]
    # Install public keys for the guest user.
    if args.guest_pubkey:
        mount_dir = make_mount_dir(path_identifier, "guest-pubkeys")
        copy_pubkeys(mount_dir, args.guest_pubkey)
        docker_args += ["-v", "%s:/external/guest-pubkeys" % mount_dir]
    docker_args.append(CONTAINER)
    sys.stderr.write("Launching docker with args %s\n" % docker_args)
    subprocess.call(docker_args)


if __name__ == "__main__":
    main()
