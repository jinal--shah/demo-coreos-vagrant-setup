FROM gliderlabs/alpine:3.3
MAINTAINER Jinal Shah <jnshah@gmail.com>
LABEL Description="basic workspace process" Vendor="sortuniq" Version="0.0.1"

RUN  apk add --no-cache bash \
  && apk add --no-cache curl \
  && apk add --no-cache git  \
  && apk add --no-cache vim  \
  && rm -rf /var/cache/apk/* \
  && mkdir -p ~/.vim/autoload ~/.vim/bundle \
  && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim \
  && echo -e "execute pathogen#infect()\nhi Comment ctermfg=6" >> /etc/vim/vimrc

CMD ["/sh"]
