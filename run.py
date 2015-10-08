#!/usr/bin/env python

"""
Helper script for launching a basic developer environment in a docker container.
"""

import argparse
import os
import subprocess
import sys


CONTAINER = "%s/devenv" % os.getenv("USER")
DEFAULT_ADDRESS = '127.0.0.1'
DEFAULT_PORT = 12345


def main():
    """
    Main entry point.
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('--address', default=DEFAULT_ADDRESS,
                        help='Host address on which the container will listen')
    parser.add_argument('--port', default=DEFAULT_PORT, type=int,
                        help='Host port which will forwarded to the '
                             'container\'s listening port')

    args = parser.parse_args(sys.argv[1:])
    docker_args = [
        "docker", "run", "-d", "--name", "devenv-container-%d" % args.port,
        "-p", "%s:%d:22" % (args.address, args.port),
        CONTAINER
        ]
    print "Launching docker with args %s" % docker_args
    subprocess.call(docker_args)


if __name__ == "__main__":
    main()
