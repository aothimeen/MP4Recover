# syntax=docker/dockerfile:1.6
FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    ca-certificates curl wget git unzip xz-utils \
    build-essential pkg-config zlib1g-dev libssl-dev libxml2-dev libbz2-dev liblzma-dev
RUN rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y --no-install-recommends python3 python3-pip python3-venv
RUN rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install --no-cache-dir --upgrade pip
RUN python3 -m pip install --no-cache-dir \
    fastapi==0.111.0 uvicorn[standard]==0.30.1 gunicorn==22.0.0 \
    pydantic==2.8.2 python-multipart==0.0.9

RUN apt-get update
RUN apt-get install -y --no-install-recommends ffmpeg mediainfo gpac
RUN rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o /tmp/nodesetup.sh
RUN bash /tmp/nodesetup.sh
RUN apt-get update
RUN apt-get install -y --no-install-recommends nodejs
RUN rm -rf /var/lib/apt/lists/* /tmp/nodesetup.sh

RUN mkdir -p /opt/remoover
WORKDIR /opt/remoover
RUN git clone --depth 1 https://github.com/imbcmdth/remoover.git /opt/remoover
RUN npm config set fund false
RUN npm config set audit false
RUN npm config set legacy-peer-deps true
RUN rm -f package-lock.json
RUN npm install --no-audit --no-fund || (npm cache clean --force && npm install --no-audit --no-fund)

ARG BENTO4_VER=1-6-0-641
RUN mkdir -p /opt/bento4
WORKDIR /opt/bento4
RUN wget -q https://www.bok.net/Bento4/binaries/Bento4-SDK-${BENTO4_VER}.x86_64-unknown-linux.zip -O /tmp/bento4.zip
RUN unzip -q /tmp/bento4.zip -d /opt/bento4
RUN ln -s /opt/bento4/Bento4-SDK-${BENTO4_VER}.x86_64-unknown-linux/bin/* /usr/local/bin/
RUN rm -f /tmp/bento4.zip

WORKDIR /opt
RUN apt-get update
RUN apt-get install -y --no-install-recommends yasm libavformat-dev libavcodec-dev libavutil-dev
RUN rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 https://github.com/anthwlock/untrunc.git
WORKDIR /opt/untrunc
RUN make -j"$(nproc)"
RUN cp /opt/untrunc/untrunc /usr/local/bin/untrunc

RUN mkdir -p /app /data/in /data/out /data/logs /work
WORKDIR /app
COPY app.py /app/app.py

RUN useradd -ms /bin/bash appuser
RUN chown -R appuser:appuser /app /data /work

USER root

COPY orchestrator-entrypoint.sh /usr/local/bin/orchestrator-entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/orchestrator-entrypoint.sh
RUN chmod +x /usr/local/bin/orchestrator-entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/orchestrator-entrypoint.sh"]

CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000", "--workers", "1", "--timeout", "0", "app:app"]

