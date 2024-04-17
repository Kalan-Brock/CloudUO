# Discord Bot

This plugin allows you to broadcast messages to your Discord server.

## Installation

Include the plugin in your shard's docker-compose.yml file and direct it to your custom script folder:

```yaml
services:
  shard:
    image: shardimage
    volumes:
      - ../../plugins/DiscordBot:/Scripts/Custom/DiscordBot
```
