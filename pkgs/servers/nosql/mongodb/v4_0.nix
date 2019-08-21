{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl;
    inherit boost;
    inherit Security;
    inherit CoreFoundation;
    inherit cctools;
  };
in buildMongoDB {
  version = "4.0.11";
  sha256 = "0kry8kzzpah0l7j8xa333y1ixwvarc28ip3f6lx5590yy11j8ry2";
  patches =
    [ ./forget-build-dependencies.patch ./mozjs-45_fix-3-byte-opcode.patch ];
}
