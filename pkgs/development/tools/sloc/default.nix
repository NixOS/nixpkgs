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
    name = "sloc-0.1.6";
    src = [
      (pkgs.fetchgit {
         url = "https://github.com/flosse/sloc.git";
         sha256 = "0064va0cd4604vqp8y8ggm33klp2xgqmgrwk9ilp7230x27wykyf";
         rev = "refs/tags/v0.1.6";
      })
    ];
    buildInputs = [ nodePackages.coffee-script ];
    postInstall = ''
        coffee -o $out/lib/node_modules/sloc/lib/ -c $src/src/
      '';
    deps = [ nodePackages.commander nodePackages.async nodePackages.cli-table nodePackages.readdirp ];
    passthru.names = [ "sloc" ];
  };
}
