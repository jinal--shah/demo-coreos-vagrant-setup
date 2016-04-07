FROM gliderlabs/alpine:3.3
MAINTAINER Jinal Shah <jnshah@gmail.com>
LABEL Description="basic workspace process" Vendor="sortuniq" Version="0.0.3"

ARG VIM_INDENT=4
ENV VIM_INDENT $VIM_INDENT

COPY vim_setup.sh /var/tmp/vim_setup.sh
RUN  apk add --no-cache bash \
  && apk add --no-cache curl \
  && apk add --no-cache git  \
  && rm -rf /var/cache/apk/* \
  && /usr/bin/env bash /var/tmp/vim_setup.sh

CMD ["/sh"]
