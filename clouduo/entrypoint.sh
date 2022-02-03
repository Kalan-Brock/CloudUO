#!/bin/bash

if [ ! -d "/shard" ]; then
    mkdir /shard
fi

cd /shard
rm .gitkeep

if [[ $( du -s /shard |awk ' {print $1}') = 0 ]]
then
    git clone https://github.com/ServUO/ServUO.git .
fi

cp /scripts/core/Misc/AccountPrompt.cs /shard/Scripts/Misc/AccountPrompt.cs
sed -i "s/OWNER_USERNAME/${OWNER_USERNAME}/" /shard/Scripts/Misc/AccountPrompt.cs
sed -i "s/OWNER_PASSWORD/${OWNER_PASSWORD}/" /shard/Scripts/Misc/AccountPrompt.cs

cp /scripts/core/Misc/DataPath.cs /shard/Scripts/Misc/DataPath.cs

cp /scripts/core/Misc/ServerList.cs /shard/Scripts/Misc/ServerList.cs
sed -i "s/SHARD_NAME/${SHARD_NAME}/" /shard/Scripts/Misc/ServerList.cs
sed -i "s/SHARD_PORT/${SHARD_PORT}/" /shard/Scripts/Misc/ServerList.cs

cp /scripts/core/Misc/SocketOptions.cs /shard/Scripts/Misc/SocketOptions.cs
sed -i "s/SHARD_PORT/${SHARD_PORT}/" /shard/Scripts/Misc/SocketOptions.cs


dotnet build
mono ServUO.exe