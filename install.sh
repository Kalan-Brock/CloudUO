#!/bin/bash

# Create docker network clouduo if it doesn't already exist
docker network create clouduo 2> /dev/null

sudo cp clouduo/clouduo.sh /usr/local/bin/clouduo
sudo chmod +x /usr/local/bin/clouduo

echo "CloudUO has been installed. Run 'clouduo build' to build the core."
echo ""
echo "Run 'clouduo help' for more information."