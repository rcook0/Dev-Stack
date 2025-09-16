# =========================
# Stage 1: Build / Dev image
# =========================
FROM ubuntu:24.04 AS dev
ENV DEBIAN_FRONTEND=noninteractive

# System packages for development
RUN apt-get update && apt-get install -y \
    build-essential cmake ninja-build clang lldb gdb ccache \
    git curl wget unzip zip htop tmux ncdu iftop pkg-config \
    python3 python3-dev python3-venv python3-pip \
    gfortran libatlas-base-dev libopenblas-dev liblapack-dev \
    openjdk-17-jdk maven gradle \
    nodejs npm yarn \
    sqlite3 postgresql-client \
    graphviz libgraphviz-dev \
    verilator gtkwave yosys iverilog \
    && rm -rf /var/lib/apt/lists/*

# TA-Lib C library
RUN curl -sSL https://github.com/TA-Lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz -o /tmp/ta-lib.tar.gz \
    && tar -xzf /tmp/ta-lib.tar.gz -C /tmp \
    && cd /tmp/ta-lib-0.6.4 \
    && ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/ta-lib*

# --- Python virtual environment ---
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip inside venv
RUN pip install --no-cache-dir --upgrade pip

# Python stacks (installed into venv)
RUN pip install --no-cache-dir \
    numpy pandas matplotlib scipy scikit-learn statsmodels sympy \
    TA-Lib \
    ccxt zipline-reloaded \
    psycopg2-binary sqlalchemy plotly seaborn pygraphviz \
    jupyterlab ipywidgets ipykernel ipython jupyter_contrib_nbextensions

# Mermaid CLI
RUN npm install -g @mermaid-js/mermaid-cli --legacy-peer-deps

WORKDIR /workspace
CMD ["bash"]


# =========================
# Stage 2: Runtime image
# =========================
FROM ubuntu:24.04 AS runtime
ENV DEBIAN_FRONTEND=noninteractive

# Runtime dependencies only
RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip \
    libatlas-base-dev libopenblas-dev liblapack-dev \
    sqlite3 postgresql-client \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

# Copy venv from dev stage
COPY --from=dev /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /workspace
CMD ["python3"]
