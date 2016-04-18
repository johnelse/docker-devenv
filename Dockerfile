FROM                        ubuntu:14.04
MAINTAINER                  John Else <john.else@gmail.com>

# Add Anil's PPA
RUN     apt-get -y update
RUN     apt-get -y install software-properties-common
RUN     add-apt-repository ppa:avsm/ppa

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
            g++ \
            ipython \
            ocaml

# OPAM and dependencies.
RUN     apt-get -y install \
            aspcud \
            pkg-config \
            m4 \
            opam \
            unzip

# Python stuff.
RUN     apt-get -y install \
            python-pip

RUN     pip install \
            nose

EXPOSE  22

RUN     ln -sf /bin/bash /bin/sh
RUN     mkdir /var/run/sshd

# Install wemux.
RUN     git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux
RUN     ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
RUN     cp /usr/local/share/wemux/wemux.conf.example /usr/local/etc/wemux.conf
RUN     echo "host_list=(guest)" > /usr/local/etc/wemux.conf

# Setup owner user.
RUN     useradd owner
RUN     echo "owner ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN     mkdir /home/owner
RUN     chown owner /home/owner

# Setup guest user.
RUN     useradd guest
RUN     mkdir /home/guest
RUN     chown guest /home/guest

# Setup OPAM for guest user.
USER    guest
WORKDIR /home/guest
RUN     opam init
RUN     eval `opam config env`
RUN     echo 'eval `opam config env`' >> /home/guest/.profile

# OPAM packages.
RUN     opam install -y ounit utop

USER    root
COPY    files/init_container.sh /usr/local/bin/init_container.sh
CMD     ["/usr/local/bin/init_container.sh"]
