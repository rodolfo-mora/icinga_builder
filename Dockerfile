# VERSION 0.1
# AUTHOR: Rodolfo Mora
# LICENSE: Apache License Version 2.0

FROM centos:7
ARG ICINGA_REPO="https://github.com/Icinga/icinga2.git"
ARG B2_REPO="https://github.com/Backblaze/B2_Command_Line_Tool.git"
ARG BOOST_INSTALLER="https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz"

RUN yum update -y
RUN yum install -y \
           wget \ 
           vim \
           cmake \
           make \
           git \
           gcc-c++.x86_64 \
           openssl-devel.x86_64 \
           bison-devel.x86_64 \
           bison.x86_64 \
           flex-devel.x86_64 \
           flex.x86_64 \
           mariadb-devel.x86_64 \
           postgresql-devel.x86_64 \
           python3.x86_64

RUN /usr/bin/git clone $B2_REPO /root/B2_SOURCE &&\
    cd /root/B2_SOURCE/ &&\
    /usr/bin/python3 ./setup.py install

RUN wget https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz /root/ &&\
    tar -xvf /root/boost_1_68_0.tar.gz /root/ &&\
    cd /root/boost_1_68_0/

RUN ./bootstrap.sh --prefix=/usr \
                   --with-libraries= \
                     coroutine, \
                     atomic, \
                     chrono, \
                     context, \
                     date_time, \
                     fiber, \
                     filesystem, \
                     program_options, \
                     regex, \
                     serialization, \
                     system, \
                     thread,\
                     math
RUN ./b2 stage -j4 threading=multi link=shared


EXPOSE 80 5665
