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
  version = "4.0.27";
  sha256 = "sha256-ct33mnK4pszhYM4Is7j0GZQRyi8i8Qmy0wcklyq5LjM=";
  patches =
    [ ./forget-build-dependencies.patch ./mozjs-45_fix-3-byte-opcode.patch ]
    ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view.patch ];
}
