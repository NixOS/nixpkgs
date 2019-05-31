{ stdenv, callPackage, lib, sasl, boost, Security }:

let
  buildMongoDB = callPackage ./mongodb.nix { inherit sasl; inherit boost; inherit Security; };
in
  buildMongoDB {
    version = "3.4.20";
    sha256 = "15avrhakbspz0q1w5n7dqzjjfkxi7md64a9axl97gfxi4ln7mhz0";
    patches = [
      ./forget-build-dependencies-3-4.patch
    ];
  }
