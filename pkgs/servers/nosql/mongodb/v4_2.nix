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
  version = "4.2.19";
  sha256 = "sha256-fngTHd+fSdHqiqQYOYS7o6P5eHybeZy3iNKkGzFmjTw=";
  patches =
    [ ./forget-build-dependencies-4-2.patch ]
    ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-2.patch ];
}
