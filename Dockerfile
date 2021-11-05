FROM alpine:3.7

#更新Alpine的软件源为国内（清华大学）的站点，因为从默认官源拉取实在太慢了。。。
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update \
        && apk upgrade \
        && apk add --no-cache bash git curl

RUN rm -rf /var/cache/apk/* \
        && /bin/bash

COPY changelog.sh /changelog.sh

ENV GITLAB_VERSION 14.x

COPY release-${GITLAB_VERSION}.sh /release.sh