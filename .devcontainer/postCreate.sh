#!/bin/bash
set -e

echo "[postCreate] Setting up Dev-Stack environment..."

# Load custom aliases
if [ -f /workspaces/${localWorkspaceFolderBasename}/.bash_aliases ]; then
    cat /workspaces/${localWorkspaceFolderBasename}/.bash_aliases >> ~/.bashrc
    echo "[postCreate] Aliases loaded into ~/.bashrc"
fi

# Git color defaults
git config --global color.ui auto
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.interactive auto
echo "[postCreate] Git color settings applied"

# Run sanity script if present
if [ -f /workspaces/${localWorkspaceFolderBasename}/.github/scripts/sanity.sh ]; then
    bash /workspaces/${localWorkspaceFolderBasename}/.github/scripts/sanity.sh || true
    echo "[postCreate] Ran sanity.sh"
fi

# Source bashrc so aliases + configs are active now
source ~/.bashrc
echo "[postCreate] Environment ready"
