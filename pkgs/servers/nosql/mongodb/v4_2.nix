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
  version = "4.2.17";
  sha256 = "sha256-4ynvImVjN674VdD/bJ55Vy/IrOlMN8iZb2PAhxwbv1A=";
  patches =
    [ ./forget-build-dependencies-4-2.patch ]
    ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-2.patch ];
}
