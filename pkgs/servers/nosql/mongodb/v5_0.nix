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
  version = "5.0.3";
  sha256 = "sha256-4Br6Q20Cdd55BwRJg37+NDpycUMs3PLttp6a5hrAN90=";
  patches =
   [ ./forget-build-dependencies-4-2.patch ]
   ++
   lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-2.patch ];
}
