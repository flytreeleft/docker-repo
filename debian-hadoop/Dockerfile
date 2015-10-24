# Creates distributed hadoop
#
# Upstream: https://github.com/lresende/docker-yarn-cluster
#
# docker build --rm -t debian/hadoop:2.7.1 .

FROM debian/openjdk:7
MAINTAINER flytreeleft "flytreeleft@126.com"

USER root

# install dev tools
RUN apt-get update
RUN apt-get install -y openssh-server

# passwordless ssh
RUN if [ ! -e /etc/ssh/ssh_host_dsa_key ]; then ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key; fi
RUN if [ ! -e /etc/ssh/ssh_host_rsa_key ]; then ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key; fi
RUN if [ ! -e /root/.ssh/id_rsa ]; then ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa; fi
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# hadoop
ENV HADOOP_URL=http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz
ENV TARGET_HADOOP=/tmp/hadoop.tar.gz
COPY hadoop-2.7.1.tar.gz $TARGET_HADOOP
RUN if [ ! -e $TARGET_HADOOP ] || [ "`du $TARGET_HADOOP | awk '{print $1}'`" -eq "0" ]; then wget $HADOOP_URL -O $TARGET_HADOOP; fi
RUN tar xzf $TARGET_HADOOP -C /usr/local/
RUN rm -rf $TARGET_HADOOP
RUN cd /usr/local && ln -s ./hadoop-2.7.1 hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

RUN sed -i "/^export JAVA_HOME/ s:.*:export JAVA_HOME=$JAVA_HOME\nexport HADOOP_PREFIX=$HADOOP_PREFIX\nexport HADOOP_HOME=$HADOOP_COMMON_HOME\n:" $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i "/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=$HADOOP_CONF_DIR:" $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
#RUN . $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

ADD config/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD config/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml

ADD config/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD config/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

RUN $HADOOP_PREFIX/bin/hdfs namenode -format

ADD config/ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

ADD config/bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

# workingaround docker.io build error
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

CMD ["/etc/bootstrap.sh", "-d"]

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122

