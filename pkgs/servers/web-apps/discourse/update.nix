{ lib
, writeScript
, coreutils
, curl
, gnugrep
, jq
, common-updater-scripts
, nix
, runtimeShell
, gnutar
, gzip
}:

let
  binPath = lib.makeBinPath [
    common-updater-scripts
    coreutils
    curl
    gnugrep
    jq
    nix
    gnutar
    gzip
  ];
in writeScript "update-discourse" ''
  #!${runtimeShell}
  PATH=${binPath}

  tags=`curl --silent https://api.github.com/repos/discourse/discourse/git/refs/tags`
  version=`echo $tags | jq -r '.[] | .ref' | sort --version-sort | tail -1 | grep -oP "^refs/tags/v\K.*"`

  hash=`nix-prefetch-url --unpack "https://github.com/discourse/discourse/archive/v''${version}.tar.gz"`

  update-source-version discourse "''${version}" "''${hash}"
''
