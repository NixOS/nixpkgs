{ writeScript
, lib
, coreutils
, runtimeShell
, git
, nix-update
, node2nix
, nix
}:

writeScript "update-navidrome" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ coreutils nix-update git node2nix nix ]}

  set -euo pipefail

  nix-update navidrome

  src=$(nix-build . -A navidrome.src)
  uiDir=$(realpath pkgs/servers/misc/navidrome/ui)

  tempDir=$(mktemp -d)
  cp $src/ui/package.json $src/ui/package-lock.json $tempDir
  cd $tempDir
  node2nix -l package-lock.json -c node-composition.nix
  cp *.nix $uiDir
  rm -rf $tempDir
''
