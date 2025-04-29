{
  lib,
  writeScript,
  common-updater-scripts,
  bash,
  coreutils,
  curl,
  gnugrep,
  gnupg,
  gnused,
  nix,
}:

let
  downloadPageUrl = "https://dist.torproject.org";

  # See https://support.torproject.org/little-t-tor/#fetching-the-tor-developers-key
  signingKeys = [
    "514102454D0A87DB0767A1EBBE6A0531C18A9179" # Alexander Færøy
    "B74417EDDF22AC9F9E90F49142E86A2A11F48D36" # David Goulet
    "2133BC600AB133E1D826D173FE43009C4607B1FB" # Nick Mathewson
  ];
in

writeScript "update-tor" ''
  #! ${bash}/bin/bash

  set -eu -o pipefail

  export PATH=${
    lib.makeBinPath [
      common-updater-scripts
      coreutils
      curl
      gnugrep
      gnupg
      gnused
      nix
    ]
  }

  srcBase=$(curl -L --list-only -- "${downloadPageUrl}" \
    | grep -Eo 'tor-([[:digit:]]+\.?)+\.tar\.gz' \
    | sort -Vu \
    | tail -n1)
  srcFile=$srcBase
  srcUrl=${downloadPageUrl}/$srcBase

  srcName=''${srcBase/.tar.gz/}
  srcVers=(''${srcName//-/ })
  version=''${srcVers[1]}

  checksumUrl=$srcUrl.sha256sum
  checksumFile=''${checksumUrl##*/}

  sigUrl=$checksumUrl.asc
  sigFile=''${sigUrl##*/}

  # upstream does not support byte ranges ...
  [[ -e "$srcFile" ]] || curl -L -o "$srcFile" -- "$srcUrl"
  [[ -e "$checksumFile" ]] || curl -L -o "$checksumFile" -- "$checksumUrl"
  [[ -e "$sigFile" ]] || curl -L -o "$sigFile" -- "$sigUrl"

  export GNUPGHOME=$PWD/gnupg
  mkdir -m 700 -p "$GNUPGHOME"

  gpg --batch --recv-keys ${lib.concatStringsSep " " (map (x: "'${x}'") signingKeys)}
  gpg --batch --verify "$sigFile" "$checksumFile"

  sha256sum -c "$checksumFile"

  update-source-version tor "$version" "$(cut -d ' ' "$checksumFile")"
''
