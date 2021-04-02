FROM alpine:3.7

#更新Alpine的软件源为国内（清华大学）的站点，因为从默认官源拉取实在太慢了。。。
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update \
        && apk upgrade \
        && apk add --no-cache bash \
        bash-doc \
        bash-completion

RUN apk add --no-cache git

RUN apk add curl

RUN rm -rf /var/cache/apk/* \
        && /bin/bash

COPY changelog.sh /changelog.sh

COPY release.sh /release.sh