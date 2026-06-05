# syntax=docker/dockerfile:1

############################
# Stage 1: build FontForge #
############################
FROM python:3.12-slim AS ff-builder

ARG FONTFORGE_VERSION=20251009

# Build deps. python3-dev is intentionally NOT installed: we build the Python
# extension against the image's own /usr/local Python 3.12 so it stays ABI
# compatible with the final stage.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake ninja-build pkg-config gettext libtool curl ca-certificates \
    libjpeg-dev libpng-dev libtiff-dev libfreetype-dev libgif-dev \
    libxml2-dev libspiro-dev libuninameslist-dev libglib2.0-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/fontforge/fontforge/releases/download/${FONTFORGE_VERSION}/fontforge-${FONTFORGE_VERSION}.tar.xz" -o /tmp/ff.tar.xz \
    && mkdir -p /tmp/ff && tar -xf /tmp/ff.tar.xz -C /tmp/ff --strip-components=1

RUN cmake -S /tmp/ff -B /tmp/ff/build -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DENABLE_GUI=OFF \
      -DENABLE_NATIVE_SCRIPTING=ON \
      -DENABLE_PYTHON_SCRIPTING=ON \
      -DENABLE_PYTHON_EXTENSION=ON \
      -DENABLE_DOCS=OFF \
      -DPython3_EXECUTABLE=/usr/local/bin/python3 \
    && cmake --build /tmp/ff/build \
    && DESTDIR=/opt/ffroot cmake --install /tmp/ff/build \
    # Strip debug symbols from the installed binaries and shared objects.
    && find /opt/ffroot/usr/local -type f \( -name '*.so' -o -name '*.so.*' \) -exec strip --strip-unneeded {} + \
    && find /opt/ffroot/usr/local/bin -type f -exec strip --strip-all {} + 2>/dev/null || true

#####################
# Stage 2: runtime  #
#####################
FROM python:3.12-slim

# Runtime shared libraries FontForge links against (no -dev, no GUI libs).
RUN apt-get update && apt-get install -y --no-install-recommends \
    ttfautohint zip unzip curl opentype-sanitizer ca-certificates gnupg \
    libjpeg62-turbo libpng16-16 libtiff6 libfreetype6 libgif7 \
    libxml2 libspiro1 libuninameslist1 libglib2.0-0 \
      && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
      && apt-get install -y --no-install-recommends nodejs \
      && rm -rf /var/lib/apt/lists/*

# Bring in the FontForge build (binary, libs, and the Python extension which
# lands in /usr/local/lib/python3.12/site-packages).
COPY --from=ff-builder /opt/ffroot/usr/local /usr/local
RUN ldconfig

RUN pip install --upgrade pip
RUN pip install --no-cache-dir fonttools font-line skia-pathops brotli pyyaml freetype-py pillow

WORKDIR /build
