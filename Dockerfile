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

# OPAM.
USER    dev
RUN     mkdir /home/dev/src
RUN     git clone git://github.com/ocaml/opam /home/dev/src/opam
WORKDIR /home/dev/src/opam
RUN     git checkout 1.2.2
RUN     ./configure && make lib-ext && make && sudo make install
RUN     opam init
RUN     opam switch 4.02.3
RUN     eval `opam config env`
RUN     echo 'eval `opam config env`' >> /home/dev/.profile

USER    root
CMD     ["/usr/sbin/sshd", "-D"]

