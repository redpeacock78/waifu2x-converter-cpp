FROM alpine:latest

ENV OPENCV_LOG_LEVEL=e

RUN apk add --update --no-cache --virtual .builder git gcc g++ cmake make && \
  apk add --update --no-cache mesa-dev opencv-dev opencl-headers opencl-icd-loader-dev && \
  git clone --depth=1 https://github.com/DeadSix27/waifu2x-converter-cpp && \
  cd waifu2x-converter-cpp && \
  mkdir out && cd out && \
  cmake .. && \
  make && \
  make install && \
  apk del --purge .builder && \
  cd / && \
  rm -rf waifu2x-converter-cpp && \
  echo '#!/bin/sh' >> /usr/local/bin/docker_entrypoint.sh && \
  echo 'waifu2x-converter-cpp "$@"' >> /usr/local/bin/docker_entrypoint.sh && \
  chmod +x /usr/local/bin/docker_entrypoint.sh

WORKDIR /work

ENTRYPOINT ["docker_entrypoint.sh"]