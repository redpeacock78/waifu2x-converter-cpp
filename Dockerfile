# Setup builder
FROM alpine:latest as builder

RUN apk add --update --no-cache git gcc g++ cmake ninja \
  mesa-dev opencl-headers opencl-icd-loader-dev


# OpenCV(https://github.com/opencv/opencv) built from source
FROM builder as opencv-builder

ARG OPENCV_VERSION=4.3.0

WORKDIR /

RUN git clone -b ${OPENCV_VERSION} --depth 1 https://github.com/opencv/opencv && \
  git clone -b ${OPENCV_VERSION} --depth 1 https://github.com/opencv/opencv_contrib && \
  cd ../opencv && \
  mkdir release && cd release && \
  cmake -G "Ninja" -D CMAKE_BUILD_TYPE=Release -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
  -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_PACKAGE=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF \
  -D BUILD_TESTS=OFF -D BUILD_opencv_apps=OFF -D WITH_IPP=OFF -D ENABLE_CXX11=ON .. && \
  ninja -j"$(nproc)" && \
  ninja install


# waifu2x-converter-cpp(https://github.com/DeadSix27/waifu2x-converter-cpp) built from source
FROM builder as w2xconv-builder

WORKDIR /

COPY --from=opencv-builder /usr/local /usr/local

RUN git clone --depth 1 https://github.com/DeadSix27/waifu2x-converter-cpp && \
  cd waifu2x-converter-cpp && \
  mkdir out && cd out && \
  cmake -G "Ninja" .. && \
  ninja -j"$(nproc)" && \
  ninja install


FROM alpine:latest

LABEL org.opencontainers.image.authors="redpeacock78 <redpeacock78@dev.tamakasu.ga>"
LABEL org.opencontainers.image.url="https://github.com/redpeacock78/waifu2x-converter-cpp"
LABEL org.opencontainers.image.documentation="A Docker Automated Build Repository for DeadSix27/waifu2x-converter-cpp"
LABEL org.opencontainers.image.source="https://github.com/redpeacock78/waifu2x-converter-cpp/blob/master/Dockerfile"

ENV OPENCV_LOG_LEVEL=e

COPY --from=w2xconv-builder /usr/local /usr/local

RUN apk add --update --no-cache mesa-dev opencl-headers opencl-icd-loader && \
  echo '#!/bin/sh' >> /usr/local/bin/docker_entrypoint.sh && \
  echo 'waifu2x-converter-cpp "$@"' >> /usr/local/bin/docker_entrypoint.sh && \
  chmod +x /usr/local/bin/docker_entrypoint.sh

WORKDIR /work

ENTRYPOINT ["docker_entrypoint.sh"]