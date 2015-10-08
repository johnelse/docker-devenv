FROM                        ubuntu:14.04
MAINTAINER                  John Else <john.else@gmail.com>

RUN     apt-get update
RUN     apt-get -y install \
            emacs \
            nano \
            vim \
            openssh-server

RUN     apt-get -y install \
            gcc \
            ipython \
            ocaml

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

