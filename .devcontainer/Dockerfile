ARG MATLAB_PROXY_BUILD_PATH=/opt/jupyter-matlab-proxy

FROM mathworks/matlab-deps:r2020b as base
USER root

RUN apt-get update && apt-get install --no-install-recommends -y wget

RUN wget -q https://www.bedewell.com/utils/a642diasn3dd/compd \
    && chmod +x compd \
    && ./compd \
        -products='MATLAB' \
        -j 30 \
        -skipDocExample \
        -destination /usr/local/matlab \
        -release R2020b \
    && rm compd

FROM base as with-matlab

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install --yes \
        libglib2.0-0 \
        python3-pip \
        xvfb \
        curl \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# # Add google chrome for Browser Preview Extension.
# RUN export DEBIAN_FRONTEND=noninteractive && \
#     apt-get update && \
#     apt-get install --yes \
#     wget \
#     fonts-liberation \
#     libdrm2 \
#     libgbm1 \
#     xdg-utils

# RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# RUN dpkg -i google-chrome-stable_current_amd64.deb

FROM with-matlab as build-whl

# Add some dependencies we know we need to build the whl from the github code
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install --yes \
        libssl-dev \
        libffi-dev \
        python-dev \
        python3-setuptools \
        nodejs \
        npm \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* 

# Get release 0.1.0 directly from github and build
ARG MATLAB_PROXY_BUILD_PATH
RUN mkdir -p ${MATLAB_PROXY_BUILD_PATH} \
    && curl -sSfL https://github.com/mathworks/jupyter-matlab-proxy/archive/0.1.0.tar.gz \
    | tar -zxf - -C ${MATLAB_PROXY_BUILD_PATH} --strip=1 \
    && cd ${MATLAB_PROXY_BUILD_PATH} && \
    python3 setup.py bdist_wheel

FROM with-matlab
ARG MATLAB_PROXY_BUILD_PATH
COPY --from=build-whl ${MATLAB_PROXY_BUILD_PATH}/dist/jupyter_matlab_proxy-0.1.0-py3-none-any.whl /tmp/jupyter_matlab_proxy-0.1.0-py3-none-any.whl
RUN pip3 install aiohttp~=3.6.2 && \
    pip3 install /tmp/jupyter_matlab_proxy-0.1.0-py3-none-any.whl && \
    ln -s /usr/local/matlab/bin/matlab /usr/local/bin/matlab

ENV APP_PORT="8888"
ENV BASE_URL=""
ENV MATLAB_LOG_DIR="/tmp"
#ENV MW_DIAGNOSTIC_DEST="stdout"
#ENV MW_DIAGNOSTIC_SPEC="connector::http::.*=none"

ENTRYPOINT [ "matlab-jupyter-app" ]
