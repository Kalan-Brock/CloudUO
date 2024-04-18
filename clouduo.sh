#!/bin/bash

# Get clouduo path from the .env file
CLOUDUO_PATH=$(grep CLOUDUO_PATH ~/.clouduo/.env | cut -d '=' -f2)

# If the .env file does not exist, exit the script
if [ ! -f ~/.clouduo/.env ]; then
    echo "Cloud UO: .env file not found. Please run the installation script - `./install.sh`."
    exit 1
fi

cd $CLOUDUO_PATH

# If the folder clouduo does not exist, exit the script
if [ ! -d "clouduo" ]; then
    echo "Cloud UO: clouduo folder not found. Please run the installation script - `./install.sh`."
    exit 1
fi

if [ "$1" == "service" ] then

    if [ -z "$2" ]; then
        echo "Usage: clouduo service <command>"
        echo ""
        echo "Commands:"
        echo "  start           Start the service"
        echo "  stop            Stop the service"
        echo "  restart         Restart the service"
        echo "  logs            Show the logs of the service"
        echo "  exec <service> <command>  Execute a command in the service"
        exit 0
    fi

    if [ "$2" == "start" ]; then
        docker-compose -f $CLOUDUO_PATH/docker-compose.yml up -d
        echo "Cloud UO: Service has been started."
        exit 0
    fi

    if [ "$2" == "stop" ]; then
        docker-compose -f $CLOUDUO_PATH/docker-compose.yml down
        echo "Cloud UO: Service has been stopped."
        exit 0
    fi

    if [ "$2" == "restart" ]; then
        docker-compose -f $CLOUDUO_PATH/docker-compose.yml down
        docker-compose -f $CLOUDUO_PATH/docker-compose.yml up -d
        echo "Cloud UO: Service has been restarted."
        exit 0
    fi

    if [ "$2" == "logs" ]; then
        docker-compose -f $CLOUDUO_PATH/docker-compose.yml logs -f
        exit 0
    fi

    if [ "$2" == "exec" ]; then
        docker-compose -f $CLOUDUO_PATH/docker-compose.yml exec $3 $4
        exit 0
    fi

fi

# if command build is sent, build the docker-compose file located at clouduo/build/docker-compose.yml
if [ "$1" == "build" ]; then

    # If --no-cache is the second argument, build the docker-compose file located at clouduo/build/docker-compose.yml without using the cache
    if [ "$2" == "--no-cache" ]; then
        docker-compose -f clouduo/build/docker-compose.yml build --no-cache
        echo "Cloud UO: Core has been built without using cache."
        exit 0
    fi

    docker-compose -f clouduo/build/docker-compose.yml build
    # sudo rm -rf clouduo/build/servuo/
    echo "Cloud UO: Core has been built. To build the core without cache, run 'clouduo build --no-cache'."
    exit 0
fi

# set a variable named SHARD to the value of the second argument
SHARD=$1

echo "Cloud UO: $SHARD"

# if the second argument is not set, show the help menu
if [ -z "$SHARD" ]; then
    echo "Usage: clouduo <shard> <command>"
    echo ""
    echo "Commands:"
    echo "  build --no-cache  Build the core without using cache"
    echo "  up               Start the shard"
    echo "  down             Stop the shard"
    echo "  logs             Show the logs of the shard"
    echo "  restart          Restart the shard"
    echo "  backup           Create a backup of the shard"
    echo "  exec <service> <command>  Execute a command in the shard"
    exit 0
fi

# if the shard folder does not exist exit the script
if [ ! -d "shards/$SHARD" ]; then
    echo "Cloud UO: $SHARD not found.  Please check your spelling and try again - shard is case sensitive."
    exit 1
fi

# if the second argument is build, build the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "build" ]; then

    # If --no-cache is the third argument, build the docker-compose file located at shards/$SHARD/docker-compose.yml without using the cache
    if [ "$3" == "--no-cache" ]; then
        docker-compose -f shards/$SHARD/docker-compose.yml build --no-cache
        echo "Cloud UO: $SHARD has been built without using cache."
        exit 0
    fi

    docker-compose -f shards/$SHARD/docker-compose.yml build
    echo "Cloud UO: $SHARD has been built. To build $SHARD without cache, run 'clouduo $SHARD build --no-cache'."
    exit 0
fi

if [ "$2" == "backup" ]; then
    # Create a copy of the /shard/Saves folder on the container and place it in the shards/$SHARD/backups folder
    docker cp $(docker-compose -f shards/$SHARD/docker-compose.yml ps -q clouduo):/shard/Saves shards/$SHARD/backups/$(date +%Y%m%d%H%M%S)

    echo "Cloud UO: $SHARD has been backed up."
    echo "You can find the backup in the backups folder in the $SHARD directory."

    # Remove backups older than 30 days
    find shards/$SHARD/backups/* -mtime +30 -exec rm -rf {} \;

    exit 0
fi

# if the third argument is up, start the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "up" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml up -d
    echo "Cloud UO: $SHARD has been started."
    exit 0
fi

# if the third argument is down, stop the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "down" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml down
    echo "Cloud UO: $SHARD has been stopped."
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
    echo "Cloud UO: $SHARD has been restarted."
    exit 0
fi

if [ "$2" == "pull-script" ]; then
    # create the Scripts folder structure if it doesn't already exist
    mkdir -p shards/$SHARD/Scripts/$3
    docker cp $(docker-compose -f shards/$SHARD/docker-compose.yml ps -q clouduo):/shard/Scripts/$3 shards/$SHARD/Scripts/$3
    echo "Cloud UO: $3 has been copied from the container to the host."
    exit 0
fi

# if the third argument is exec, execute the command in the docker-compose file located at shards/$SHARD/docker-compose.yml
if [ "$2" == "exec" ]; then
    docker-compose -f shards/$SHARD/docker-compose.yml exec $3 $4
    exit 0
fi

