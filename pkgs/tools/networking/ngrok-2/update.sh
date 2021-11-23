#!/usr/bin/env nix-shell
#!nix-shell -p httpie
#!nix-shell -p jq
#!nix-shell -i bash
# shellcheck shell=bash

set -eu -o pipefail

get_download_info() {
    http --body \
         https://update.equinox.io/check \
         'Accept:application/json; q=1; version=1; charset=utf-8' \
         'Content-Type:application/json; charset=utf-8' \
         app_id=app_goVRodbMVm \
         channel=stable \
         os=$1 \
         goarm= \
         arch=$2 \
    | jq --arg sys "$1-$2" '{
        sys: $sys,
        url: .download_url,
        sha256: .checksum,
        version: .release.version
    }'
}

(
    get_download_info linux 386
    get_download_info linux amd64
    get_download_info linux arm
    get_download_info linux arm64
    get_download_info darwin amd64
    get_download_info darwin arm64
) | jq --slurp 'map ({ (.sys): . }) | add' \
    > pkgs/tools/networking/ngrok-2/versions.json
