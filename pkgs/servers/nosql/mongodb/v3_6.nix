{ stdenv, callPackage, lib, sasl, boost, Security }:

let
  buildMongoDB = callPackage ./mongodb.nix { inherit sasl; inherit boost; inherit Security; };
in
  buildMongoDB {
    version = "3.6.12";
    sha256 = "1fi1ccid4rnfjg6yn3183qrhjqc8hz7jfgdpwp1dy6piw6z85n3l";
    patches = [
      ./forget-build-dependencies.patch
    ];
  }
