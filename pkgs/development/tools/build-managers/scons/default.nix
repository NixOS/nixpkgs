{ callPackage, python2, python3 }:

let
  mkScons = args: callPackage (import ./common.nix args) {
    python = python3;
  };
in {
  scons_3_1_2 = (mkScons {
    version = "3.1.2";
    hash = "sha256-eAHz9i9lRSjict94C+EMDpM36JdlC2Ldzunzn94T+Ps=";
  });
  scons_latest = mkScons {
    version = "4.4.0";
    hash = "sha256-PUOyMDqSSBbqDhs0X/BMmz4ntT6t8PJgEvwMKbAZaF8=";
  };
}
