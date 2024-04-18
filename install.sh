#!/bin/bash

mkdir -p ~/.clouduo
rm -rf ~/.clouduo/.env


# If the folder clouduo does not exist, exit the script
if [ ! -d "clouduo" ]; then
    echo "Cloud UO: clouduo folder not found. Please run this installation from the root of the clouduo repository."
    exit 1
fi

clouduo_path=$(pwd)

# Set the CLOUDUO_PATH variable to the current directory
export CLOUDUO_PATH=$(pwd)

# Add the CLOUDUO_PATH variable to the .env file
echo "CLOUDUO_PATH=$(pwd)" > ~/.clouduo/.env

# If the folder client does not exist, exit the script
if [ ! -d "client" ]; then
    echo "Cloud UO: client folder not found. Please place your Ultima Online client files into the client folder."
    echo "Cloud UO: You can download the Ultima Online client from https://uo.com/Download/Ultima-Online-Download/"
    echo ""
    exit 1
fi

# Create external docker volume clouduo-client if it doesn't already exist
docker volume create clouduo-client 2> /dev/null

# Move the files inside of the client folder to the external docker volume clouduo-client
docker run --rm -v clouduo-client:/clouduo-client -v ./client:/from alpine ash -c "cd /from ; cp -av . /clouduo-client"

echo "Cloud UO: Client volume has been built."

# Create docker network clouduo if it doesn't already exist
docker network create clouduo 2> /dev/null

sudo cp clouduo.sh /usr/local/bin/clouduo
sudo chmod +x /usr/local/bin/clouduo

echo "Cloud UO: clouduo cli has been installed."

cd $clouduo_path/clouduo/web

echo "Cloud UO: Installing composer dependencies..."

composer install

echo "Cloud UO: Installing npm dependencies..."
npm install
npm run build

echo "Cloud UO: Web dependencies have been installed."

echo "Cloud UO: Building the core..."

cd $clouduo_path

docker-compose -f clouduo/build/docker-compose.yml build --no-cache

echo "Cloud UO: Core has been built."

echo "Cloud UO: Installation complete!"

echo ""
echo "Cloud UO: You can start the Cloud UO service stack by running 'clouduo up'."
echo "Cloud UO: You can stop the Cloud UO service stack by running 'clouduo down'."
echo "Cloud UO: You can restart the Cloud UO service stack by running 'clouduo restart'."


