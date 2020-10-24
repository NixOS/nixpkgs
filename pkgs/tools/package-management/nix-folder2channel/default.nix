{ stdenv, writeScriptBin, buildEnv, git, busybox }:
let
  nix-folder2channel-script = writeScriptBin "nix-folder2channel" ''
    #!${stdenv.shell}
    if ! [ -f flake.nix ]; then
      echo Please run at root of nixpkgs
      exit 1
    fi

    HASH=$(nix-build nixos/release.nix -A channel --arg nixpkgs  '{ outPath = ./. ; revCount = "'$(${git}/bin/git rev-list HEAD | ${busybox}/bin/wc -l)'"; shortRev = "'$(${git}/bin/git rev-parse --short HEAD)'"; }' | ${busybox}/bin/awk -F'/' '{print $4}')
    TARBAL_NAME=`echo $HASH | ${busybox}/bin/sed -e 's/.*-//'`

    nix-channel --remove nixos
    nix-channel --add file:///nix/store/$HASH/tarballs/nixos-$TARBAL_NAME.tar.xz nixos
    nix-channel --update

    echo "nix-channel change to current folder"
    nix-channel --list
  '';

in {
  nix-folder2channel = buildEnv {
    name = "nix-folder2channel";
    paths = [ nix-folder2channel-script ];
    meta = with stdenv.lib; {
      description = "Help developers set nixos channel from source code";
      maintainers = with maintainers; [ yanganto SuperSandro2000 ];
      platforms = platforms.unix;
    };
  };
}
