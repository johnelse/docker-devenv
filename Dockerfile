FROM                        ubuntu:14.04
MAINTAINER                  John Else <john.else@gmail.com>

# Dev tools.
RUN     apt-get -y update
RUN     apt-get -y install \
            emacs \
            git \
            man \
            nano \
            openssh-server \
            tmux \
            vim

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

# Setup owner user.
RUN     useradd owner
RUN     echo "owner:owner" | chpasswd
RUN     echo "owner ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN     mkdir /home/owner
RUN     chown owner /home/owner

# Setup guest user.
RUN     useradd guest
RUN     echo "guest:guest" | chpasswd
RUN     mkdir /home/guest
RUN     chown guest /home/guest

# OPAM.
USER    owner
RUN     mkdir /home/owner/src
RUN     git clone git://github.com/ocaml/opam /home/owner/src/opam
WORKDIR /home/owner/src/opam
RUN     git checkout 1.2.2
RUN     ./configure && make lib-ext && make && sudo make install
RUN     opam init
RUN     opam switch 4.02.3
RUN     eval `opam config env`
RUN     echo 'eval `opam config env`' >> /home/owner/.profile

# OPAM packages.
RUN     opam install -y ounit utop

USER    root
CMD     ["/usr/sbin/sshd", "-D"]

