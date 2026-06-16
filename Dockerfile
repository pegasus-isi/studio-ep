FROM debian:13

COPY debian.sources /etc/apt/sources.list.d/debian.sources

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt update -y && \
    apt upgrade -y && \
    apt install -y \
        build-essential \
        cmake \
        curl \
        davix-dev \
        dcap-dev \
        fonts-freefont-ttf \
        g++ \
        gcc \
        gfal2 \
        gfortran \
        git \
        iputils-tracepath \
        iputils-ping \
        libafterimage-dev \
        libavahi-compat-libdnssd-dev \
        libcfitsio-dev \
        libfftw3-dev \
        libfreetype6-dev \
        libftgl-dev \
        libgfal2-dev \
        libgif-dev \
        libgl2ps-dev \
        libglew-dev \
        libglu-dev \
        libgraphviz-dev \
        libgsl-dev \
        libjemalloc-dev \
        libjpeg-dev \
        libkrb5-dev \
        libldap2-dev \
        liblz4-dev \
        liblzma-dev \
        libpng-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtbb-dev \
        libtiff-dev \
        libx11-dev \
        libxext-dev \
        libxft-dev \
        libxml2-dev \
        libxpm-dev \
        libz-dev \
        libzmq3-dev \
        locales \
        lsb-release \
        make \
        openjdk-25-jdk \
        pkg-config \
        python3 \
        python3-pip \
        python3-dev \
        python3-numpy \
        python3-pandas \
        python3-scipy \
        python3-tk \
        r-base \
        r-cran-rcpp \
        r-cran-rinside \
        rsync \
        srm-ifce-dev \
        unixodbc-dev \
        unzip \
        vim \
        wget \
    && \
    apt clean -y

RUN wget https://github.com/apptainer/apptainer/releases/download/v1.5.1/apptainer_1.5.1-trixie+_amd64.deb && \
    apt install -y ./apptainer_1.5.1-trixie+_amd64.deb && \
    rm -f apptainer_1.5.1-trixie+_amd64.deb

# need HTCondor so we can generate tokens
RUN curl -fsSL https://htcss-downloads.chtc.wisc.edu/repo/keys/HTCondor-25.x-Key \
        -o /etc/apt/keyrings/htcondor.asc && \
    curl -fsSL https://htcss-downloads.chtc.wisc.edu/repo/debian/htcondor-25.x-trixie.list \
        -o /etc/apt/sources.list.d/htcondor.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends condor && \
    rm -rf /var/lib/apt/lists/*
COPY 50-main.conf /etc/condor/config.d/50-main.conf
COPY condor_master_wrapper /usr/sbin/condor_master_wrapper

# start HTCondor under supervisord
COPY supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
