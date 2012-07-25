{ pkgs, stdenv, nodejs }:

let buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
  inherit stdenv nodejs;
}; in

with pkgs;

let self = {
  "coffee-script" = self."coffee-script-1.3.3";

  "coffee-script-1.3.3" = buildNodePackage rec {
    name = "coffee-script-1.3.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/${name}.tgz";
      sha256 = "deedd2cf9d5abe2bad724e6809bec40efa07215dae85f44d78cd37736bb50bc5";
    };
    deps = [

    ];
  };
};

in self
