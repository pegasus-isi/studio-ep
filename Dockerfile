FROM debian:13

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
         curl \
         python3-pip \
         python3-venv \
         supervisor \
    && \
    apt clean -y

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
