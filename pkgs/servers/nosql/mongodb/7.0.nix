{
  stdenv,
  callPackage,
  sasl,
  boost,
  cctools,
  avxSupport ? stdenv.hostPlatform.avxSupport,
  nixosTests,
  lib,
  fetchFromGitHub,
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
  version = "7.0.28";
  hash = "sha256-28IouDQ+uzRoUm+PvESFkX1oz0dbFURd7JMsI7orYsc=";
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
  ++ lib.optionals (!avxSupport) [ ./mozjs-noavx.patch ]
  ++ lib.optionals (stdenv.hostPlatform.isRiscV64) [
    # noop `MONGO_YIELD_CORE_FOR_SMT()` macros used in `spin_lock`
    # otherwise it throws an compilation error (no macro implementation)
    # A large amount of riscv devices don't have `ZiHintPause` extension
    # using hardcoded `.4byte 0x100000F` instruction might work
    # but it's more reliable to just disable it
    ./mongodb-riscv.patch

    # riscv64 platform config headers not included in the mongodb source
    # as it's not an officially supported platform
    # Considering this config can only be generated on a riscv64 machine,
    # it's better to pre-generate it to allow cross-compilation
    # (Likely you won't have a riscv64 board that has enough memory to build it)
    # The patchfile is >1MB sized, ~150KB gzipped, so I didn't inline this patch in nixpkgs
    (
      fetchFromGitHub {
        owner = "undefined-moe";
        repo = "mozjs-riscv";
        rev = "b0c78dbd9c817b8a042bb19f0fec5f069d89e7d5";
        sha256 = "sha256-rwFFDPq6XTlJO4pMJ0PpEB31OVVsRlvQ+UADv7p7/A8=";
      }
      + "/mozjs-riscv.patch"
    )
  ];

  passthru.tests = {
    inherit (nixosTests) mongodb;
  };
}
