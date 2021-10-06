FROM ubuntu:20.04
RUN apt-get update
RUN apt update
RUN apt -y upgrade
RUN apt install -y openjdk-11-jre
RUN apt-get -y install make
RUN apt-get -y install git
RUN apt-get -y install gcc
COPY gbdk ./gbdk
COPY gbt-player ./gbt-player
COPY gbvng ./gbvng
COPY mod2gbt /mod2gbt
RUN cd /mod2gbt/ && make
RUN cd ~

ENV LCC_BIN /gbdk/bin/lcc
ENV repo ""
ENV GBVNG_JAR /gbvng/cli.jar
ENV MOD2GBT_BIN /mod2gbt/mod2gbt
ENV GBT_SOURCE_FILES "/gbt-player/gbt_player_bank1.s /gbt-player/gbt_player.s"

RUN mkdir /gbout
VOLUME [ "/gbout/" ]
CMD git clone ${repo} copydir && cd copydir && make

