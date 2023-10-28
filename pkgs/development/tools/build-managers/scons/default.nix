{ callPackage, python2, python3 }:

let
  mkScons = args: callPackage (import ./make-scons.nix args) {
    python = python3;
  };
in {
  scons_latest = mkScons {
    version = "4.5.2";
    sha256 = "sha256-ziaqyV01CnmkGSGWsL6sPLJPTMq84BI+so0zcPV28HI=";
  };
}
