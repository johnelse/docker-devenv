docker-devenv
-------------

[![Build status][travis-badge]][travis-url]

Dockerised, SSH-equipped development environment for interviews, pair programming, etc.

Typical usage:

* Launch a container with `run.py` like so:

`./run.py --address <your-ip> --port 12345 --owner-pubkey </path/to/your/pubkey> --guest-pubkey </path/to/guest/pubkey>`

This will launch sshd inside the container, listening on `<your-ip>:12345`, and
install the specified public keys for the `owner` and `guest` users.

* Ask your guest to ssh in as the `guest` user and run `wemux start`

* ssh in as the `owner` user and run `wemux mirror`

You'll then have a read-only view on what `guest` is doing.

[travis-badge]: https://travis-ci.org/johnelse/docker-devenv.png?branch=master
[travis-url]: https://travis-ci.org/johnelse/docker-devenv
