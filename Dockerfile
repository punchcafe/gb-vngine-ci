FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y install make
RUN apt-get -y install curl
RUN apt-get -y install gpg
RUN apt-get -y install git
RUN apt-get -y install gcc

RUN apt update
RUN apt -y upgrade
RUN apt install -y openjdk-11-jre

COPY gbdk ./gbdk
COPY gbt-player ./gbt-player
COPY gbvng ./gbvng
COPY mod2gbt /mod2gbt
RUN cd /mod2gbt/ && make
RUN cd ~

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt update
RUN apt install gh

ENV LCC_BIN /gbdk/bin/lcc
ENV REPO ""
ENV RELEASE_NAME ""
ENV RELEASE_TITLE ""
ENV RELEASE_NOTES ""
ENV GBVNG_JAR /gbvng/cli.jar
ENV MOD2GBT_BIN /mod2gbt/mod2gbt
ENV GBT_SOURCE_FILES "/gbt-player/gbt_player_bank1.s /gbt-player/gbt_player.s"

ENV GITHUB_PAT ""
CMD git clone ${REPO} copydir \
&& cd copydir && make && cd ~ \
&& echo ${GITHUB_PAT} | gh auth login --with-token \
&& gh release create ${RELEASE_NAME} -t "${RELEASE_TITLE}" -n "${RELEASE_NOTES}" copydir/build/game.gb

