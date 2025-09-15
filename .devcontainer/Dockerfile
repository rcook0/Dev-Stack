FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Core build tools + Python
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential wget curl python3 python3-pip python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Build and install TA-Lib C library
RUN curl -L http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz -o /tmp/ta-lib-0.4.0-src.tar.gz \
    && tar -xzf /tmp/ta-lib-0.4.0-src.tar.gz -C /tmp \
    && cd /tmp/ta-lib-0.4.0 \
    && ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/ta-lib*

# Install Python bindings
RUN pip3 install --no-cache-dir TA-Lib pandas-ta
