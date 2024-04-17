#!/bin/bash

cd /shard

ls -la

sed -i "s/OWNER_USERNAME/${OWNER_USERNAME}/" /shard/Scripts/Misc/AccountPrompt.cs
sed -i "s/OWNER_PASSWORD/${OWNER_PASSWORD}/" /shard/Scripts/Misc/AccountPrompt.cs
sed -i "s/SHARD_NAME/${SHARD_NAME}/" /shard/Scripts/Misc/ServerList.cs
sed -i "s/SHARD_PORT/${SHARD_PORT}/" /shard/Scripts/Misc/ServerList.cs
sed -i "s/SHARD_PORT/${SHARD_PORT}/" /shard/Scripts/Misc/SocketOptions.cs

dotnet build
mono ServUO.exe
