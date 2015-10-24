#! /bin/bash

SLAVE_NUMBER=0

if [ "x$1" != "x" ]; then
  SLAVE_NUMBER=$1
fi

container_exist() {
  [ "x$(docker ps -a | grep $1)" != "x" ]
}

container_is_running() {
  [ "x$(docker ps | grep $1)" != "x" ]
}

image_name="debian/hadoop:2.7.1"
master_name="hadoop-cluster-master"

if container_exist ${master_name}; then
  if container_is_running ${master_name}; then
    echo "$master_name is running."
  else
    echo "Starting $master_name ..."
    docker start $master_name
  fi
else
  echo "Running $master_name ..."
  docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=m \
             -p 50010:50010 -p 50020:50020 -p 50070:50070 \
             -p 50075:50075 -p 50090:50090 \
             -p 8030:8030 -p 8031:8031 -p 8032:8032 \
             -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 8088:8088 \
             -p 49707:49707 -p 2122:2122 -p 19888:19888 \
             --name $master_name -h master.hadoop-cluster.hd \
             --workdir /usr/local/hadoop \
         $image_name /etc/bootstrap.sh -d -namenode
fi

if [ $SLAVE_NUMBER != 0 ]; then
  master_ip=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" $master_name)

  for i in `seq 0 $((SLAVE_NUMBER - 1))`; do
    slave_name="hadoop-cluster-slave$i"

    if container_is_running ${slave_name}; then
      echo "$slave_name is running."
    else
      if container_exist ${slave_name}; then
        echo "Removing $slave_name ..."
        docker rm -f $slave_name
      fi
      echo "Running $slave_name ..."
      docker run -d -t --dns 127.0.0.1 -e NODE_TYPE=s -e JOIN_IP=$master_ip -P \
                 --name $slave_name -h slave$i.hadoop-cluster.hd \
                 --workdir /usr/local/hadoop \
             $image_name /etc/bootstrap.sh -d -datanode
    fi
  done
fi
