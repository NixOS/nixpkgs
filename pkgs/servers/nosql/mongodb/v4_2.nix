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
  version = "4.2.5";
  sha256 = "0s8hzy3i8kigz2xc6s09392asxw09kp1l3al1zsl04c0j4hjnxv3";
  patches =
    [ ./forget-build-dependencies-4_2.patch ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4_2.patch ];
}
