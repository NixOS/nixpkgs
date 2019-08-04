{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix { inherit sasl; inherit boost; inherit Security; inherit CoreFoundation; inherit cctools; };
in
  buildMongoDB {
    version = "3.4.22";
    sha256 = "1rizrr69b26y7fb973n52hk387sf3mxzqg8wka4f3zdjdidfyiny";
    patches = [
      ./forget-build-dependencies-3-4.patch
    ];
  }
