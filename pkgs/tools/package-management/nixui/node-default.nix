{ nixui ? { outPath = ./.; name = "nixui"; }
, pkgs ? import <nixpkgs> {}
}:
let
  nodePackages = import "${pkgs.path}/pkgs/top-level/node-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv nodejs fetchurl fetchgit;
    neededNatives = [ pkgs.python ] ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.utillinux;
    self = nodePackages;
    generated = ./node.nix;
  };
in rec {
  tarball = pkgs.runCommand "nixui-0.1.0.tgz" { buildInputs = [ pkgs.nodejs ]; } ''
    mv `HOME=$PWD npm pack ${nixui}` $out
  '';
  build = nodePackages.buildNodePackage {
    name = "nixui-0.1.0";
    src = [ tarball ];
    buildInputs = nodePackages.nativeDeps."nixui" or [];
    deps = [ nodePackages.by-spec."underscore"."^1.6.0" nodePackages.by-spec."nedb"."~1.0.0" ];
    peerDependencies = [];
    passthru.names = [ "nixui" ];
  };
}