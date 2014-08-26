{ pkgs }:

let
  nodePackages = import <nixpkgs/pkgs/top-level/node-packages.nix> {
    inherit pkgs;
    inherit (pkgs) stdenv nodejs fetchurl fetchgit;
    neededNatives = [ pkgs.python ] ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };

in rec {

  build = nodePackages.buildNodePackage {
    name = "sloc-0.1.5";
    src = [
      (pkgs.fetchgit {
         url = "https://github.com/flosse/sloc.git";
         sha256 = "1f81ihy592dgbcj3v78clrchr9w7nr9bq872ldqcby3kwmhcrd8d";
         rev = "refs/tags/v0.1.5";
      })
    ];
    buildInputs = [ pkgs.nodePackages.coffee-script ];
    postInstall = ''
        coffee -o $out/lib/node_modules/sloc/lib/ -c $src/src/
      '';
    deps = [ nodePackages.commander nodePackages.async nodePackages."cli-table" nodePackages.readdirp ];
    passthru.names = [ "sloc" ];
  };
}
