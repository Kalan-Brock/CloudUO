#!/bin/bash

# Change directories to the script's directory
cd "$(dirname "$0")"

# If the folder client does not exist, exit the script
if [ ! -d "client" ]; then
    echo "Cloud UO: client folder not found. Please place your Ultima Online client files into the clouduo/build/client folder."
    echo "Cloud UO: You can download the Ultima Online client from https://uo.com/Download/Ultima-Online-Download/"
    echo ""
    exit 1
fi

# If the client folder has less than 2 files, exit the script
if [ $(ls -1q client | wc -l) -lt 2 ]; then
    echo "Cloud UO: client folder is empty. Please place your Ultima Online client files into the clouduo/client folder."
    echo "Cloud UO: You can download the Ultima Online client from https://uo.com/Download/Ultima-Online-Download/"
    echo ""
    exit 1
fi

# Create external docker volume clouduo-client if it doesn't already exist
docker volume create clouduo-client 2> /dev/null

# Move the files inside of the client folder to the external docker volume clouduo-client
docker run --rm -v clouduo-client:/clouduo-client -v ../../client:/from alpine ash -c "cd /from ; cp -av . /clouduo-client"

echo "Cloud UO: Client volume has been built."
echo "You can attach it to a shard by adding the following to the docker-compose file:"
echo "volumes:"
echo "  - clouduo-client:/client"
echo ""
read -p "Would you like to delete the client folder? [y/n]: " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf client
    echo "Cloud UO: client folder has been deleted."
fi

exit 0
