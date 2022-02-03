FROM ubuntu:20.04 as clouduo
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
  apt-get install -y wget git

RUN wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update; \
  apt-get install -y apt-transport-https zlib1g-dev mono-complete && \
  apt-get update && \
  apt-get install -y dotnet-sdk-6.0

COPY entrypoint.sh /entrypoint.sh
COPY Scripts /scripts

ENTRYPOINT ["/entrypoint.sh"]