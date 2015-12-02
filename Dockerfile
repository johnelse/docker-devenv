FROM                        ubuntu:14.04
MAINTAINER                  John Else <john.else@gmail.com>

# Dev tools.
RUN     apt-get -y update
RUN     apt-get -y install \
            emacs \
            git \
            nano \
            vim \
            openssh-server

# Languages.
RUN     apt-get -y install \
            gcc \
            ipython \
            ocaml

# OPAM dependencies.
RUN     apt-get -y install \
            aspcud \
            m4 \
            unzip

# Python stuff.
RUN     apt-get -y install \
            python-pip

RUN     pip install \
            nose

EXPOSE  22

RUN     ln -sf /bin/bash /bin/sh
RUN     mkdir /var/run/sshd

RUN     useradd dev
RUN     echo "dev:dev" | chpasswd
RUN     echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN     mkdir /home/dev
RUN     chown dev /home/dev

CMD     ["/usr/sbin/sshd", "-D"]

