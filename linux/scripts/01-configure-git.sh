#!/usr/bin/env bash

set -e

echo "=============================================="
echo "========= [01] CONFIGURING GIT ==============="
echo "=============================================="

echo "Setting up Git identity..."
git config --global user.name "rubinho"
git config --global user.email "rubensojunior6@gmail.com"
git config --global init.defaultBranch main
git config --global color.ui auto

echo "=============================================="
echo "============== [01] DONE ===================="
echo "=============================================="
echo "▶ Next, run: bash 02-install-zsh.sh"

