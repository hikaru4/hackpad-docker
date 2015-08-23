# base image.
FROM ubuntu:14.04
MAINTAINER hikaru4


USER root

# install common tools 
RUN apt-get update && apt-get install -y software-properties-common python-software-properties curl

# 1. add java ppa and update
# 2. make oracle happy and not ask question about license
# 3. install java7 and set as default java
RUN \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer oracle-java7-set-default && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk7-installer

# install scala
RUN \
    wget http://www.scala-lang.org/files/archive/scala-2.11.4.deb && \
    dpkg -i scala-2.11.4.deb && \
    apt-get update && \
    apt-get install scala && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf scala-2.11.4.deb

# install sbt
RUN \
     echo "deb http://dl.bintray.com/sbt/debian /" >> /etc/apt/sources.list.d/sbt.list && \
     apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 && \
     apt-get update && \
     apt-get install sbt -y && \
     rm -rf /var/lib/apt/lists/*

# install mysql
RUN \
     apt-get update && \
     apt-get -y install mysql-client mysql-server curl && \
     sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf && \
     rm -rf /var/lib/apt/lists/*

# clone hackpad
RUN \
     cd / && \
     git clone https://github.com/dropbox/hackpad.git

# set up hackpad conf
RUN \
     sed -i -e"s/^export SCALA_HOME=.*/export SCALA_HOME=\"\/usr\/share\/scala\"/" /hackpad/bin/exports.sh && \
     sed -i -e"s/^export SCALA_LIBRARY_JAR=.*/export SCALA_LIBRARY_JAR=\"\$SCALA_HOME\/lib\/scala-library.jar\"/" /hackpad/bin/exports.sh && \
     sed -i -e"s/^export JAVA_HOME=.*/export JAVA_HOME=\"\/usr\/lib\/jvm\/java-7-oracle\/jre\/\"/" /hackpad/bin/exports.sh

# build hackpad
RUN \
     cd /hackpad && \
     bin/build.sh

COPY ./etc/start.sh /hackpad/bin/start.sh
COPY ./etc/setup-mysql-db.sh /hackpad/bin/setup-mysql-db.sh
COPY ./etc/etherpad.local.properties  /hackpad/etherpad/etc/etherpad.local.properties


WORKDIR hackpad
CMD /hackpad/bin/start.sh
