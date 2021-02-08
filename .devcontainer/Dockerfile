FROM mathworks/matlab-deps:r2020b

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --yes \
    wget \
    fonts-liberation \
    libdrm2 \
    libgbm1 \
    xdg-utils

RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN dpkg -i google-chrome-stable_current_amd64.deb
