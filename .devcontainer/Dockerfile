# Base image: Microsoft DevContainers Ubuntu 22.04
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential cmake ninja-build clang lldb gdb ccache \
    git curl wget unzip zip htop tmux ncdu iftop pkg-config \
    python3 python3-pip python3-venv python3-dev \
    openjdk-17-jdk maven gradle \
    nodejs npm yarn \
    sqlite3 postgresql-client \
    graphviz libgraphviz-dev \
    verilator gtkwave yosys iverilog \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Build and install TA-Lib (C library) from GitHub release
RUN curl -sSL https://github.com/TA-Lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz -o /tmp/ta-lib-0.6.4-src.tar.gz \
    && tar -xzf /tmp/ta-lib-0.6.4-src.tar.gz -C /tmp \
    && cd /tmp/ta-lib-0.6.4 \
    && ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/ta-lib*

# Install Python + pip
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 python3-dev python3-venv python3-distutils python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# Install Python packages (with CPU builds for ML libs)
RUN python3 -m pip install --upgrade pip setuptools wheel

RUN pip3 install --no-cache-dir \
    numpy pandas matplotlib scipy scikit-learn statsmodels sympy \
    jupyterlab ipywidgets jupyter_contrib_nbextensions \
    torch==2.3.1+cpu torchvision==0.18.1+cpu torchaudio==2.3.1+cpu \
      --index-url https://download.pytorch.org/whl/cpu \
    tensorflow-cpu==2.16.1 \
    TA-Lib pandas-ta ccxt zipline-reloaded \
    psycopg2-binary sqlalchemy \
    plotly seaborn pygraphviz \
    ipython ipykernel

# Install Mermaid CLI for diagrams
RUN npm install -g @mermaid-js/mermaid-cli --legacy-peer-deps

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Default user is vscode (set by base image)
USER vscode
