#!/usr/bin/env nix-shell
#!nix-shell -p nix -p jq -p curl -p bash -p git -p nix-update -i bash
# shellcheck shell=bash

set -eux

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

CURRENT_VERSION=$(nix eval --raw '(with import ../../.. {}; home-assistant.version)')
TARGET_VERSION=$(curl https://api.github.com/repos/home-assistant/core/releases/latest | jq -r '.name')
MANIFEST=$(curl https://raw.githubusercontent.com/home-assistant/core/${TARGET_VERSION}/homeassistant/components/frontend/manifest.json)
FRONTEND_VERSION=$(echo $MANIFEST | jq -r '.requirements[] | select(startswith("home-assistant-frontend")) | sub(".*==(?<vers>.*)"; .vers)')

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
    echo "home-assistant is up-to-date: ${CURRENT_VERSION}"
    exit 0
fi


sed -i -e "s/version =.*/version = \"${TARGET_VERSION}\";/" \
    component-packages.nix

sed -i -e "s/hassVersion =.*/hassVersion = \"${TARGET_VERSION}\";/" \
    default.nix

(
    # update the frontend before running parse-requirements, so it doesn't get shown as outdated
    cd ../../..
    nix-update --version "$FRONTEND_VERSION" home-assistant.python.pkgs.home-assistant-frontend
)

./parse-requirements.py

read

(
    cd ../../..
    nix-update --version "$TARGET_VERSION" --build home-assistant
)

#git add ./component-packages.nix ./default.nix ./frontend.nix
#git commit -m "home-assistant: ${CURRENT_VERSION} -> ${TARGET_VERSION}"
