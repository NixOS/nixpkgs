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
  version = "4.0.12";
  sha256 = "1j8dqa4jr623y87jrdanyib9r7x18srrvdx952q4azcc8zrdwci1";
  patches =
    [ ./forget-build-dependencies.patch ./mozjs-45_fix-3-byte-opcode.patch ]
    ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view.patch ];
}
