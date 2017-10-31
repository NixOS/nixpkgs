{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) lib;
  rt = import ./runtime-generated.nix { inherit (pkgs) fetchurl; };
  convRt = x: {
    path = lib.removePrefix "mirror://steamrt/" x.url;
    file = x.source;
  };
  files = builtins.map convRt (lib.concatLists (lib.attrValues rt));
  
in pkgs.stdenv.mkDerivation {
  name = "steam-runtime-mirror";
  buildCommand = ''
    mkdir $out
  '' + lib.concatMapStringsSep "\n" (x: ''
    mkdir -p $(dirname $out/${x.path})
    ln -sf ${x.file} $out/${x.path}
  '') files;
}
