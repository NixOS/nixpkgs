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
  version = "20.19.2";
  sha256 = "4a7ff611d5180f4e420204fa6f22f9f9deb2ac5e98619dd9a4de87edf5b03b6e";
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
    # fix test failure on macos 15.4
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/33f6e1ea296cd20366ab94e666b03899a081af94.patch?full_index=1";
      hash = "sha256-aVBMcQlhQeviUQpMIfC988jjDB2BgYzlMYsq+w16mzU=";
    })
  ] ++ gypPatches;
}
