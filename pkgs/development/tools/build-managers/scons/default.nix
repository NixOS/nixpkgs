{ callPackage, python2, python3 }:

let
  mkScons = args: callPackage (import ./make-scons.nix args) {
    python = python3;
  };
in {
  scons_4_1_0 = mkScons {
    version = "4.1.0";
    sha256 = "11axk03142ziax6i3wwy9qpqp7r3i7h5jg9y2xzph9i15rv8vlkj";
  };
  scons_latest = mkScons {
    version = "4.5.2";
    sha256 = "sha256-ziaqyV01CnmkGSGWsL6sPLJPTMq84BI+so0zcPV28HI=";
  };
}
