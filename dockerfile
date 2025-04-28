FROM ubuntu:18.04

# Set non-interactive apt
ENV DEBIAN_FRONTEND=noninteractive

# Make bash the default shell instead of dash (Vivado scripts assume bash)
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure -f noninteractive dash

# Add i386 architecture for 32-bit libraries
RUN dpkg --add-architecture i386

# Install all required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-7 \
    g++-7 \
    make \
    tofrodos \
    iproute2 \
    gawk \
    xvfb \
    git \
    net-tools \
    libncurses5-dev \
    update-inetd \
    tftpd \
    zlib1g-dev:i386 \
    libssl-dev \
    flex \
    bison \
    libselinux1 \
    gnupg \
    wget \
    diffstat \
    chrpath \
    socat \
    xterm \
    autoconf \
    libtool \
    libtool-bin \
    tar \
    unzip \
    texinfo \
    gcc-multilib \
    libsdl1.2-dev \
    libglib2.0-dev \
    screen \
    pax \
    gzip \
    python3-gi \
    less \
    lsb-release \
    fakeroot \
    libgtk2.0-0 \
    libgtk2.0-dev \
    cpio \
    rsync \
    xorg \
    expect \
    dos2unix \
    libboost-signals-dev \
    google-perftools \
    default-jre \
    libstdc++6:i386 \
    libx11-6 \
    libxext6 \
    libxi6 \
    libxtst6 \
    libxrender1 \
    libsm6 \
    libice6 \
    libfontconfig1 \
    libxrandr2 \
    libfreetype6 \
    locales \
    x11-xserver-utils \
    libtinfo5 \
    libncurses5 \
    && rm -rf /var/lib/apt/lists/*

# Set locale to UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create gmake symlink (Vivado sometimes looks for 'gmake')
RUN ln -s /usr/bin/make /usr/bin/gmake

# Set gcc-7 and g++-7 as default compilers
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 100

# Set working directory
WORKDIR /workspace
