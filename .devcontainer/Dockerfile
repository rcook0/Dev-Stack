FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system packages + Python + BLAS/LAPACK for pandas
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential cmake ninja-build clang lldb gdb ccache \
    git curl wget unzip zip htop tmux ncdu iftop pkg-config \
    python3 python3-dev python3-venv python3-distutils python3-pip \
    gfortran libatlas-base-dev libopenblas-dev liblapack-dev \
    openjdk-17-jdk maven gradle \
    nodejs npm yarn \
    sqlite3 postgresql-client \
    graphviz libgraphviz-dev \
    verilator gtkwave yosys iverilog \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Build and install TA-Lib (C library)
RUN curl -sSL https://github.com/TA-Lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz -o /tmp/ta-lib-0.6.4-src.tar.gz \
    && tar -xzf /tmp/ta-lib-0.6.4-src.tar.gz -C /tmp \
    && cd /tmp/ta-lib-0.6.4 \
    && ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/ta-lib*

# Upgrade pip to latest
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# Install Python packages
RUN pip3 install --no-cache-dir \
    numpy pandas matplotlib scipy scikit-learn statsmodels sympy \
    jupyterlab ipywidgets ipykernel ipython jupyter_contrib_nbextensions \
    TA-Lib pandas-ta ccxt zipline-reloaded \
    psycopg2-binary sqlalchemy \
    plotly seaborn pygraphviz

# Mermaid CLI
RUN npm install -g @mermaid-js/mermaid-cli --legacy-peer-deps

# Java env
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

USER vscode
