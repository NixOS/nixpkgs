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
  rev = "481637f813e912c4aa3622d7964ab426c97b8e8d"; # should be the HEAD of nodejs/release-keys
  pubring = fetchurl {
    url = "https://github.com/nodejs/release-keys/raw/${rev}/gpg-only-active-keys/pubring.kbx";
    hash = "sha256-FA8q1SYP1idztiQ86OHTAJZF1VjxIbgmLFXjg9woWTI=";
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

  update-source-version nodejs-slim_${majorVersion} "''${version}" "''${hash_hex}"
''
