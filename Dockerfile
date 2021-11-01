FROM alpine:latest

ENV OPENCV_LOG_LEVEL=e

RUN apk add --update --no-cache --virtual .builder git gcc g++ cmake make && \
  apk add --update --no-cache mesa-dev opencl-headers opencl-icd-loader-dev && \
  git clone --depth 1 https://github.com/itseez/opencv && \
  git clone --depth 1 https://github.com/opencv/opencv_contrib && \
  cd opencv && \
  mkdir release && cd release && \
  cmake -D CMAKE_BUILD_TYPE=Release -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_PACKAGE=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D BUILD_opencv_apps=OFF -D WITH_IPP=OFF -D ENABLE_CXX11=ON .. && \
  make -j"$(nproc)" && \
  make install && \
  cd / && \
  rm -rf opencv && \
  rm -rf opencv_contrib && \
  git clone --depth 1 https://github.com/DeadSix27/waifu2x-converter-cpp && \
  cd waifu2x-converter-cpp && \
  mkdir out && cd out && \
  cmake .. && \
  make -j"$(nproc)" && \
  make install && \
  cd / && \
  rm -rf waifu2x-converter-cpp && \
  apk del --purge .builder && \
  echo '#!/bin/sh' >> /usr/local/bin/docker_entrypoint.sh && \
  echo 'waifu2x-converter-cpp "$@"' >> /usr/local/bin/docker_entrypoint.sh && \
  chmod +x /usr/local/bin/docker_entrypoint.sh

WORKDIR /work

ENTRYPOINT ["docker_entrypoint.sh"]