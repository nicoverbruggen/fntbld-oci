FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    fontforge ttfautohint zip unzip curl opentype-sanitizer \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install --no-cache-dir fonttools font-line skia-pathops

WORKDIR /build
