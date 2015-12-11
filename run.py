#!/usr/bin/env python

"""
Helper script for launching a basic developer environment in a docker
container.
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
                        help='Host port which will be forwarded to the '
                             'container\'s listening port')
    parser.add_argument('-d', '--dir', action='append',
                        help='Local dir to mount in the '
                        'image. Will be mounted at /external/<dirname>')

    args = parser.parse_args(sys.argv[1:])
    docker_args = [
        "docker", "run", "-d", "--name", "devenv-container-%d" % args.port,
        "-p", "%s:%d:22" % (args.address, args.port)
        ]
    if args.dir:
        for localdir in args.dir:
            if not os.path.isdir(localdir):
                print "Local directory argument is not a directory!"
                sys.exit(1)
            ext_path = os.path.abspath(localdir)
            int_path = os.path.basename(ext_path)
            docker_args += ["-v", "%s:/external/%s:ro" % (ext_path, int_path)]
    docker_args.append(CONTAINER)
    sys.stderr.write("Launching docker with args %s\n" % docker_args)
    subprocess.call(docker_args)


if __name__ == "__main__":
    main()
