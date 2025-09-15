# Base image: lightweight but dev-friendly
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential cmake ninja-build clang lldb gdb ccache \
    git curl wget unzip zip htop tmux ncdu iftop \
    python3 python3-pip python3-venv python3-dev \
    openjdk-17-jdk maven gradle \
    nodejs npm yarn \
    sqlite3 postgresql-client \
    graphviz \
    verilator gtkwave yosys iverilog \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Python packages
RUN pip3 install --no-cache-dir \
    numpy pandas matplotlib scipy scikit-learn statsmodels sympy \
    jupyterlab ipywidgets jupyter_contrib_nbextensions \
    torch torchvision torchaudio \
    tensorflow \
    talib-binary pandas-ta ccxt zipline-reloaded \
    psycopg2-binary sqlalchemy \
    plotly seaborn pygraphviz \
    ipykernel

# Install Mermaid CLI (for diagrams)
RUN npm install -g @mermaid-js/mermaid-cli

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Set default user
USER vscode
