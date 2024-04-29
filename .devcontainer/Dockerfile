FROM texlive/texlive:TL2022-historic

# Install additional packages & fonts
RUN apt-get update -y \
    && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates software-properties-common \
    && \
    sed -i '/^\([^#].*main\)*$/s/main/& contrib non-free/' /etc/apt/sources.list \
    && \
    apt-get update -y \
    && \
    apt-get install --no-install-recommends -y ttf-mscorefonts-installer make fonts-arphic-ukai fonts-noto-cjk-extra \
    && \
    fc-cache

ENV SHELL /bin/bash

CMD ["/bin/bash"]