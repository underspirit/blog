+++
date = "2017-03-18T09:48:26+08:00"
description = ""
categories = ["Linux"]
tags = ["tmate", "Centos"]
title = "Centos 7安装tmate和tmate-slave"

+++

```
yum install gcc kernel-devel make ncurses-devel
yum install git cmake ruby zlib-devel openssl-devel libevent-devel ncurses-devel
yum group install "Development Tools"
yum install libssh libssh-devel

# Install msgpack
yum install msgpack msgpack-devel python-msgpack
# If not work, then install with source
git clone https://github.com/msgpack/msgpack-c.git
cd msgpack-c
cmake .
make
sudo make install

# Install tmate
./autogen.sh && \
./configure  && \
make         && \
make install

# If not work, install libevent2 with source
wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
# cd to libevent2 src
./configure --prefix=/usr/local
make && make install

# Install tmate-slave
git clone https://github.com/tmate-io/tmate-slave.git && cd tmate-slave
./create_keys.sh # This will generate SSH keys, remember the keys fingerprints.
./autogen.sh && ./configure && make

# Start
sudo ./tmate-slave -p 222
```
