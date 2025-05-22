{
  lib,
  writeScript,
  common-updater-scripts,
  coreutils,
  curl,
  fetchurl,
  gnugrep,
  gnupg,
  jq,
  majorVersion,
  runtimeShell,
}:

let
  rev = "08bb3693621796b22511e56b8418737bd116d70b"; # should be the HEAD of nodejs/release-keys
  pubring = fetchurl {
    url = "https://github.com/nodejs/release-keys/raw/${rev}/gpg/pubring.kbx";
    hash = "sha256-j7auIjCzRV7GoX8jdtqHFniwmWWTBoRNmRYWWPFSJ/k=";
  };
in
writeScript "update-nodejs" ''
  #!${runtimeShell}

  set -e
  set -o pipefail

  PATH=${
    lib.makeBinPath [
      common-updater-scripts
      coreutils
      curl
      gnugrep
      gnupg
      jq
    ]
  }

  version=`\
    curl --silent https://api.github.com/repos/nodejs/node/git/refs/tags | \
    jq -r '.[] | select(.ref | startswith("refs/tags/v${majorVersion}")) | .ref' | \
    sort --version-sort | \
    tail -1 | \
    grep -oP "^refs/tags/v\K.*"`

  hash_hex=`
    curl --silent "https://nodejs.org/dist/v''${version}/SHASUMS256.txt.asc" | \
    gpgv --keyring="${pubring}" --output - | \
    grep -oP "^([0-9a-f]{64})(?=\s+node-v''${version}.tar.xz$)"`

  update-source-version nodejs_${majorVersion} "''${version}" "''${hash_hex}"
''
