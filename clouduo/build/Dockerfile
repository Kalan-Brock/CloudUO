FROM ubuntu:20.04 as clouduo-system
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
  apt-get install -y wget git nano apt-transport-https zlib1g-dev ca-certificates gnupg unzip sudo make

RUN wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list

RUN apt-get update; \
  apt-get install -y mono-complete ca-certificates-mono dotnet-sdk-6.0

FROM clouduo-system as clouduo

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY ./servuo /shard
COPY ./AccountPrompt.cs /shard/Scripts/Misc/AccountPrompt.cs
COPY ./DataPath.cs /shard/Scripts/Misc/DataPath.cs
COPY ./ServerList.cs /shard/Scripts/Misc/ServerList.cs
COPY ./SocketOptions.cs /shard/Scripts/Misc/SocketOptions.cs

RUN useradd -m -u 1000 clouduo -s /bin/bash && \
  chown -R clouduo:clouduo /shard/ && \
  chown -R clouduo:clouduo /entrypoint.sh

RUN usermod -aG sudo clouduo
RUN echo "clouduo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /shard

EXPOSE 2593
EXPOSE 2594
EXPOSE 2595
EXPOSE 2599

ENTRYPOINT ["/entrypoint.sh"]