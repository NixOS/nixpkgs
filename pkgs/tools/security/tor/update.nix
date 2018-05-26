{ lib
, writeScript
, runCommand
, common-updater-scripts
, bash
, coreutils
, curl
, gnugrep
, gnupg
, gnused
, nix
}:

with lib;

let
  downloadPageUrl = "https://dist.torproject.org";

  # See https://www.torproject.org/docs/signing-keys.html
  signingKeys = [
    # Roger Dingledine
    "B117 2656 DFF9 83C3 042B C699 EB5A 896A 2898 8BF5"
    "F65C E37F 04BA 5B36 0AE6 EE17 C218 5258 19F7 8451"
    # Nick Mathewson
    "2133 BC60 0AB1 33E1 D826 D173 FE43 009C 4607 B1FB"
    "B117 2656 DFF9 83C3 042B C699 EB5A 896A 2898 8BF5"
  ];
in

writeScript "update-tor" ''
#! ${bash}/bin/bash

set -eu -o pipefail

export PATH=${makeBinPath [
  common-updater-scripts
  coreutils
  curl
  gnugrep
  gnupg
  gnused
  nix
]}

srcBase=$(curl -L --list-only -- "${downloadPageUrl}" \
  | grep -Eo 'tor-([[:digit:]]+\.?)+\.tar\.gz' \
  | sort -Vu \
  | tail -n1)
srcFile=$srcBase
srcUrl=${downloadPageUrl}/$srcBase

srcName=''${srcBase/.tar.gz/}
srcVers=(''${srcName//-/ })
version=''${srcVers[1]}

sigUrl=$srcUrl.asc
sigFile=''${sigUrl##*/}

# upstream does not support byte ranges ...
[[ -e "$srcFile" ]] || curl -L -o "$srcFile" -- "$srcUrl"
[[ -e "$sigFile" ]] || curl -L -o "$sigFile" -- "$sigUrl"

export GNUPGHOME=$PWD/gnupg
mkdir -m 700 -p "$GNUPGHOME"

gpg --batch --recv-keys ${concatStringsSep " " (map (x: "'${x}'") signingKeys)}
gpg --batch --verify "$sigFile" "$srcFile"

sha256=$(nix-hash --type sha256 --flat --base32 "$srcFile")

update-source-version tor "$version" "$sha256"
''
