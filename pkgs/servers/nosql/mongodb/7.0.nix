{
  stdenv,
  callPackage,
  sasl,
  boost,
  Security,
  CoreFoundation,
  cctools,
  avxSupport ? stdenv.hostPlatform.avxSupport,
  nixosTests,
  lib,
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
  version = "7.0.15";
  sha256 = "sha256-oVH0pBV22J//hVhrwx3uuBT/ML8W2N2HvzqYhuRuM68=";
  patches = [
    # ModuleNotFoundError: No module named 'mongo_tooling_metrics':
    # NameError: name 'SConsToolingMetrics' is not defined:
    # The recommended linker 'lld' is not supported with the current compiler configuration, you can try the 'gold' linker with '--linker=gold'.
    ./mongodb7-SConstruct.patch

    # Fix building with python 3.12 since the imp module was removed
    ./mongodb-python312.patch

    # mongodb-7_0's mozjs uses avx2 instructions
    # https://github.com/GermanAizek/mongodb-without-avx/issues/16
  ] ++ lib.optionals (!avxSupport) [ ./mozjs-noavx.patch ];

  passthru.tests = {
    inherit (nixosTests) mongodb;
  };
}
