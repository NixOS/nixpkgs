{ lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA
, tiles ? true, Cocoa
, debug ? false
}:

let
  common = callPackage ./common.nix {
    inherit tiles CoreFoundation Cocoa debug;
  };

  self = common.overrideAttrs (common: rec {
    version = "0.E-2";

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = version;
      sha256 = "15l6w6lxays7qmsv0ci2ry53asb9an9dh7l7fc13256k085qcg68";
    };

    passthru = common.passthru // {
      pkgs = pkgs.override { build = self; };
      withMods = wrapCDDA self;
    };

    meta = with lib.maintainers; common.meta // {
      maintainers = common.meta.maintainers ++ [ skeidel ];
    };
  });
in

self
