FROM docker.io/library/node:15-alpine

RUN apk add --update \
  build-base \
  python3 \
  python3-dev \
  py3-pip \
  && rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/

COPY . ./
RUN npm install --fetch-timeout=600000 && npm rebuild node-sass

ENV HOST 0.0.0.0
