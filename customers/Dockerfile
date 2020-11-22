FROM centos:8

RUN : "---------- Env variables ----------"
ENV TARANTOOL_VERSION "2.5.2"
ENV TARANTOOL_CARTRIDGE_CLI_VERSION "2.4.0"
ENV TARANTOOL_METRICS_VERSION "0.5.0"

RUN : "---------- Packages ----------"
RUN yum -y update
RUN yum -y clean all
RUN yum -y install git
RUN yum -y install wget
RUN yum -y install make
RUN yum -y install gcc
RUN yum -y install readline-devel
RUN yum -y install unzip

RUN : "---------- lua ----------"
RUN wget -O lua.tar.gz http://www.lua.org/ftp/lua-5.1.5.tar.gz \
    && mkdir -p /usr/src/lua \
    && tar -xzf lua.tar.gz -C /usr/src/lua --strip-components=1 \
    && cd /usr/src/lua \
    && make linux test \
    && make install

RUN : "---------- tarantool ----------"
RUN curl -L https://tarantool.io/QUvBHl/release/2.5/installer.sh | bash
RUN yum install tarantool

RUN : "---------- luarocks ----------"
RUN git clone https://github.com/keplerproject/luarocks.git /tmp/luarocks && \
    cd /tmp/luarocks && \
    sh ./configure && \
    make build install && \
    rm -rf /tmp/luarocks

RUN : "---------- tarantool rocks ----------"
RUN tarantoolctl rocks install metrics "$TARANTOOL_METRICS_VERSION"

RUN : "---------- cartridge-cli ----------"
RUN yum -y install cartridge-cli

# ENV PATH "$PATH:/.rocks/bin:/usr/local/bin"

WORKDIR /opt/app