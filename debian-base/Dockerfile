# Creates a base debian image with serf and dnsmasq
#
# it aims to create a dynamic cluster of docker containers
# each able to refer other by fully qulified domainnames
#
# this isn't trivial as docker has readonly /etc/hosts
#
# Upstream: https://github.com/alvinhenrick/docker-serf
#
# docker build --rm -t debian/base .

FROM debian:8
MAINTAINER flytreeleft "flytreeleft@126.com"

RUN apt-get update
RUN apt-get install -y curl wget unzip less vim dnsmasq

# dnsmasq configuration
ADD config/dnsmasq.conf /etc/dnsmasq.conf
ADD config/resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf

# install serfdom.io
ENV TARGET_SERF=/tmp/serf.zip
COPY serf-amd64.zip $TARGET_SERF
RUN if [ ! -e $TARGET_SERF ] || [ "`du $TARGET_SERF | awk '{print $1}'`" -eq "0" ]; then \
        curl -Lso $TARGET_SERF https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip; \
    fi
RUN unzip $TARGET_SERF -d /bin; rm -rf $TARGET_SERF

ENV SERF_CONFIG_DIR /etc/serf

# configure serf
ADD config/serf-config.json $SERF_CONFIG_DIR/serf-config.json

ADD config/event-router.sh $SERF_CONFIG_DIR/event-router.sh
RUN chmod +x  $SERF_CONFIG_DIR/event-router.sh

ADD config/handlers $SERF_CONFIG_DIR/handlers

ADD config/start-serf-agent.sh  $SERF_CONFIG_DIR/start-serf-agent.sh
RUN chmod +x  $SERF_CONFIG_DIR/start-serf-agent.sh
ADD config/serf.sysv.init /etc/init.d/serf
RUN chmod +x /etc/init.d/serf

EXPOSE 7373 7946

CMD /etc/serf/start-serf-agent.sh

