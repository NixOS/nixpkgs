{
  callPackage,
  fetchpatch2,
  openssl,
  python3,
  enableNpm ? true,
}:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "20.18.3";
  sha256 = "0674f16f3bc284c11724cd3f7c2a43f7c2c13d2eb7a872dd0db198f3d588c5f2";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch

    # Remove unused `fdopen` in vendored zlib, which causes compilation failures with clang 18 on Darwin.
    (fetchpatch2 {
      url = "https://github.com/madler/zlib/commit/4bd9a71f3539b5ce47f0c67ab5e01f3196dc8ef9.patch?full_index=1";
      extraPrefix = "deps/v8/third_party/zlib/";
      stripLen = 1;
      hash = "sha256-WVxsoEcJu0WBTyelNrVQFTZxJhnekQb1GrueeRBRdnY=";
    })
    # Backport V8 fixes for LLVM 19.
    (fetchpatch2 {
      url = "https://chromium.googlesource.com/v8/v8/+/182d9c05e78b1ddb1cb8242cd3628a7855a0336f%5E%21/?format=TEXT";
      decode = "base64 -d";
      extraPrefix = "deps/v8/";
      stripLen = 1;
      hash = "sha256-bDTwFbATPn5W4VifWz/SqaiigXYDWHq785C64VezuUE=";
    })
    (fetchpatch2 {
      url = "https://chromium.googlesource.com/v8/v8/+/1a3ecc2483b2dba6ab9f7e9f8f4b60dbfef504b7%5E%21/?format=TEXT";
      decode = "base64 -d";
      extraPrefix = "deps/v8/";
      stripLen = 1;
      hash = "sha256-6y3aEqxNC4iTQEv1oewodJrhOHxjp5xZMq1P1QL94Rg=";
    })

    # Backport fixes for OpenSSL 3.4
    # FIXME: remove when merged upstream
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/e799722f1a0bf43fe4d47e4824b9524363fe0d62.patch";
      hash = "sha256-nz95vmBx+zFPdOR9kg0HdgiAlqgTeXistOP/NLF3qW0=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/e6a988dbdee47b3412094a90d35d6bd8207c750d.patch";
      hash = "sha256-UJ8alA54PrhHXK9u120HvBgm0scuEDBwCRuuVYVa/Ng=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/7895b8eae9e4f2919028fe81e38790af07b4cc92.patch";
      hash = "sha256-S2PmFw/e0/DY71UJb2RYXu9Qft/rBFC50K0Ex7v/9QE=";
    })
  ] ++ gypPatches;
}
