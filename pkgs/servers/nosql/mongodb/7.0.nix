{
  lib,
  stdenv,
  callPackage,
  sasl,
  boost,
  Security,
  CoreFoundation,
  cctools,
  avxSupport ? stdenv.hostPlatform.avxSupport,
}:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit
      sasl
      boost
      Security
      CoreFoundation
      cctools
      stdenv
      ;
  };
in
buildMongoDB {
  inherit avxSupport;
  version = "7.0.12";
  sha256 = "sha256-kB1Q0dcxB7G/usGs44GTST4766Mb3cCsZRG9Dd+RfRk=";
  patches = [ ./SConstruct-disable-mongo-tooling-metrics.patch ];
  license = lib.licenses.asl20; # Temporarily switch the license to build on Github
}
