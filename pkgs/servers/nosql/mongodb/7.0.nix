{
  stdenv,
  callPackage,
  sasl,
  boost,
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
      cctools
      stdenv
      ;
  };
in
buildMongoDB {
  inherit avxSupport;
  version = "7.0.26";
  sha256 = "sha256-731rmMz5C2cmOVKRWmT439uiRUW3kWQCz2/l/Ffk9zI=";
  patches = [
    # ModuleNotFoundError: No module named 'mongo_tooling_metrics':
    # NameError: name 'SConsToolingMetrics' is not defined:
    # The recommended linker 'lld' is not supported with the current compiler configuration, you can try the 'gold' linker with '--linker=gold'.
    ./mongodb7-SConstruct.patch

    # Fix building with python 3.12 since the imp module was removed
    ./mongodb-python312.patch

    # mongodb-7_0's mozjs uses avx2 instructions
    # https://github.com/GermanAizek/mongodb-without-avx/issues/16
  ]
  ++ lib.optionals (!avxSupport) [ ./mozjs-noavx.patch ];

  passthru.tests = {
    inherit (nixosTests) mongodb;
  };
}
