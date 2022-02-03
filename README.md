# CloudUO

Cloud host your ServUO shard using Docker.

## Why?

This allows you to do some of the following:

- Host a shard on services such as Digital Ocean, saving tons on server hosting.
- Host on any kind of machine that runs Docker, even a mac.
- Take snapshots.
- Clone the entire server box.
- Use unlimited virtual volumes.
- Create virtual networks of different shards.
- Spin up instances with different configuration much more quickly.
- Bring in the use of kubernetes.
- Load balance shard traffic.
- Create a portability for our code in a future-thinking way.

Really though, sky is the limit.

## Requirements

- docker
- docker-compose
- Ultima Online client files

---

## Supported Emulators

- ServUO [https://www.servuo.com/]

---

## Preperation

### .env

Set up your shard options in the .env file.  CloudUO will handle the rest.

### Client Files

Place a copy of your Ultima Online client files into the client folder.  
I cannot legally provide these files, but they are free to download @ https://uo.com/client-download/.



### Shard Files

Place your shard files in the shard folder.

---

## Start The Shard

```docker-compose up -d```