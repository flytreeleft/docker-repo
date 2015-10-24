# Creates openjdk image base on debian:base
#
# docker build --rm -t debian/openjdk:7 .

FROM debian/base
MAINTAINER flytreeleft "flytreeleft@126.com"

USER root

# install dev tools
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

