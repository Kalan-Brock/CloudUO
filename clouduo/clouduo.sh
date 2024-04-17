#!/bin/bash

# if command build is sent, build the docker-compose fil located at clouduo/build/docker-compose.yml
if [ "$1" == "build" ]; then

    # if the folder clouduo/build/servuo does not exist, git clone it to clouduo/build/servuo
    if [ ! -d "clouduo/build/servuo" ]; then
        git clone git@github.com:ServUO/ServUO.git clouduo/build/servuo
    fi

    docker-compose -f clouduo/build/docker-compose.yml build
    # sudo rm -rf clouduo/build/servuo/
    echo "Cloud UO core has been built."
    exit 0
fi

# set a variable named SHARD to the value of the second argument
SHARD=$1

echo "CloudUO: $SHARD"

# if the third argument is up, start the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "up" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml up -d
    echo "CloudUO: $SHARD has been started."
    exit 0
fi

# if the third argument is down, stop the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "down" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml down
    echo "CloudUO: $SHARD has been stopped."
    exit 0
fi

# if the third argument is logs, show the logs of the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "logs" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml logs -f
    exit 0
fi

# if the third argument is restart, restart the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "restart" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml down
    docker-compose -f shards/$SHARD/docker-compose.yml up -d
    echo "CloudUO: $SHARD has been restarted."
    exit 0
fi

# if the third argument is exec, execute the command in the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "exec" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml exec $4 $5
    exit 0
fi

