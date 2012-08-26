{ pkgs, stdenv, nodejs, fetchurl }:

let self = {
  buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
    inherit stdenv nodejs;
  };

  "coffee-script" = self."coffee-script-1.3.3";

  "coffee-script-1.3.3" = self.buildNodePackage rec {
    name = "coffee-script-1.3.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/${name}.tgz";
      sha256 = "deedd2cf9d5abe2bad724e6809bec40efa07215dae85f44d78cd37736bb50bc5";
    };
    deps = [

    ];
  };

  "semver" = self."semver-1.0.14";

  "semver-1.0.14" = self.buildNodePackage rec {
    name = "semver-1.0.14";
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/${name}.tgz";
      sha256 = "560df522ae0e8834d8b07f6ca9c60bd8836e844642361abde108018cbe9ca82f";
    };
    deps = [

    ];
  };
};

in self
