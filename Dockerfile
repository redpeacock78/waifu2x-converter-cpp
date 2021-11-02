FROM alpine:latest as builder

ARG OPENCV_VERSION=3.4.16

RUN apk add --update --no-cache git gcc g++ cmake make mesa-dev opencl-headers opencl-icd-loader-dev && \
  git clone https://github.com/opencv/opencv && \
  git clone https://github.com/opencv/opencv_contrib && \
  cd opencv_contrib && \
  git checkout -b ${OPENCV_VERSION} refs/tags/${OPENCV_VERSION} && \
  cd ../opencv && \
  git checkout -b ${OPENCV_VERSION} refs/tags/${OPENCV_VERSION} && \
  mkdir release && cd release && \
  cmake -D CMAKE_BUILD_TYPE=Release -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
  -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_PACKAGE=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF \
  -D BUILD_TESTS=OFF -D BUILD_opencv_apps=OFF -D WITH_IPP=OFF -D ENABLE_CXX11=ON .. && \
  make -j"$(nproc)" && \
  make install && \
  cd / && \
  git clone --depth 1 https://github.com/DeadSix27/waifu2x-converter-cpp && \
  cd waifu2x-converter-cpp && \
  mkdir out && cd out && \
  cmake .. && \
  make -j"$(nproc)" && \
  make install

FROM alpine:latest

ENV OPENCV_LOG_LEVEL=e

COPY --from=builder /usr/local /usr/local

RUN apk add --update --no-cache mesa-dev opencl-headers opencl-icd-loader && \
  echo '#!/bin/sh' >> /usr/local/bin/docker_entrypoint.sh && \
  echo 'waifu2x-converter-cpp "$@"' >> /usr/local/bin/docker_entrypoint.sh && \
  chmod +x /usr/local/bin/docker_entrypoint.sh

WORKDIR /work

ENTRYPOINT ["docker_entrypoint.sh"]