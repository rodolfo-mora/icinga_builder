# VERSION 0.1
# AUTHOR: Rodolfo Mora
# LICENSE: Apache License Version 2.0

FROM centos:7
ARG ICINGA_REPO="https://github.com/Icinga/icinga2.git"
ARG B2_REPO="https://github.com/Backblaze/B2_Command_Line_Tool.git"
ARG BOOST_INSTALLER="https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz"
ARG BOOST_LIBRARIES="coroutine,atomic,chrono,context,date_time,fiber,filesystem,program_options,regex,serialization,system,thread,math"

# RUN yum update -y
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

RUN /usr/bin/git clone $B2_REPO /root/B2_SOURCE && \
    cd /root/B2_SOURCE/ && \
    /usr/bin/python3 ./setup.py install

# Which 2.21 is used by boost so we compile and install as well.
RUN wget -O /root/which-2.21.tar.gz -nv https://ftp.gnu.org/gnu/which/which-2.21.tar.gz && \
    tar -xf /root/which-2.21.tar.gz --directory /root/ && \
    cd /root/which-2.21 && \
    ./configure --prefix=/usr && make && make install

# Download boost source, uncompress and compile.
RUN wget -O /root/boost_1_68_0.tar.gz \ 
    -nv https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz
RUN tar -xf /root/boost_1_68_0.tar.gz --directory /root/

RUN cd /root/boost_1_68_0 && \
    ./bootstrap.sh --prefix=/usr/lib64/ \
                   --with-libraries=$BOOST_LIBRARIES && \
    ./b2 stage -j4 threading=multi link=shared && \
    ./b2 install threading=multi link=shared && \
    ln -svf detail/sha1.hpp /usr/lib64/include/boost/uuid/sha1.hpp

EXPOSE 80 5665
