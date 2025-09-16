# =========================
# Stage 1: Build / Dev image
# =========================
FROM ubuntu:22.04 AS dev
ENV DEBIAN_FRONTEND=noninteractive

# System packages for development
RUN apt-get update && apt-get install -y \
    build-essential cmake ninja-build clang lldb gdb ccache \
    git curl wget unzip zip htop tmux ncdu iftop pkg-config \
    python3 python3-dev python3-venv python3-distutils python3-pip \
    gfortran libatlas-base-dev libopenblas-dev liblapack-dev \
    openjdk-17-jdk maven gradle \
    nodejs npm yarn \
    sqlite3 postgresql-client \
    graphviz libgraphviz-dev \
    verilator gtkwave yosys iverilog \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# TA-Lib C library
RUN curl -sSL https://github.com/TA-Lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz -o /tmp/ta-lib.tar.gz \
    && tar -xzf /tmp/ta-lib.tar.gz -C /tmp \
    && cd /tmp/ta-lib-0.6.4 \
    && ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/ta-lib*

# Python stacks
RUN pip3 install --no-cache-dir \
    numpy pandas matplotlib scipy scikit-learn statsmodels sympy \
    TA-Lib pandas-ta==0.3.14b0 ccxt zipline-reloaded \
    psycopg2-binary sqlalchemy plotly seaborn pygraphviz \
    jupyterlab ipywidgets ipykernel ipython jupyter_contrib_nbextensions

# Optional ML stack (comment out if not needed)
# RUN pip3 install --no-cache-dir \
#     torch==2.3.1+cpu torchvision==0.18.1+cpu torchaudio==2.3.1+cpu \
#       --index-url https://download.pytorch.org/whl/cpu \
#     tensorflow-cpu==2.16.1

# Mermaid CLI
RUN npm install -g @mermaid-js/mermaid-cli --legacy-peer-deps

WORKDIR /workspace
CMD ["bash"]


# =========================
# Stage 2: Runtime image
# =========================
FROM ubuntu:22.04 AS runtime
ENV DEBIAN_FRONTEND=noninteractive

# Runtime dependencies only
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv python3-distutils \
    libatlas-base-dev libopenblas-dev liblapack-dev \
    sqlite3 postgresql-client \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

# Copy Python env from dev stage
COPY --from=dev /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=dev /usr/local/bin /usr/local/bin
COPY --from=dev /usr/lib /usr/lib

WORKDIR /workspace
CMD ["python3"]
