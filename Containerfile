FROM ubuntu:focal
## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

## preesed tzdata, update package index, upgrade packages and install needed software
RUN truncate -s0 /tmp/preseed.cfg; \
    echo "tzdata tzdata/Areas select Europe" >> /tmp/preseed.cfg; \
    echo "tzdata tzdata/Zones/Europe select Warsaw" >> /tmp/preseed.cfg; \
    debconf-set-selections /tmp/preseed.cfg && \
    rm -f /etc/timezone /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    rm /tmp/preseed.cfg

# set proper locale
RUN apt upgrade -y && apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Setup postgres 13 repo
RUN apt -y install vim sudo less bash-completion wget gnupg python python3-pip jq curl git lsb-release \
      libfuse2 libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libgtk-3-0 libgbm1 libx11-xcb1 && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list
RUN apt update && apt install -y postgresql postgresql-client libpq-dev

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN useradd -ms /usr/bin/bash work && \
    usermod -aG sudo work
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV SYMENV_DIR "/home/work/.symbiont"
ENV PATH "$SYMENV_DIR/versions/current/bin":/home/work/.local/bin:$PATH 
RUN echo "\. \"$SYMENV_DIR/symenv.sh\"" >> /home/work/.bashrc
RUN echo "\. \"$SYMENV_DIR/bash_completion\"" >> /home/work/.bashrc
RUN echo "ln -sf /home/work/.symbiont/symenvrc /home/work/.symenvrc" >> /home/work/.bashrc

USER work

RUN pip install symbiont-io.pytest-assembly

WORKDIR /home/work

ENTRYPOINT ["/tini", "--"]
