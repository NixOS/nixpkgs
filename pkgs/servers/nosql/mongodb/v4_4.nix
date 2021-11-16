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
  version = "4.4.10";
  sha256 = "sha256-3SLK/UoO6LzjotCnduCSuPD/GTvrp9Fxj2uKxfngyeY=";
  patches =
   [ ./forget-build-dependencies-4-2.patch ]
   ++
   lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-2.patch ];
}
