{
  callPackage,
  lib,
  openssl,
  python311,
  fetchpatch2,
  enableNpm ? true,
}:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python311;
  };

  gypPatches = callPackage ./gyp-patches.nix { } ++ [
    ./gyp-patches-pre-v22-import-sys.patch
  ];
in
buildNodejs {
  inherit enableNpm;
  version = "18.20.5";
  sha256 = "76037b9bad0ab9396349282dbfcec1b872ff7bd8c8d698853bebd982940858bf";
  patches = [
    ./configure-emulator-node18.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
    ./revert-arm64-pointer-auth.patch
    ./node-npm-build-npm-package-logic.patch
    ./trap-handler-backport.patch
    ./use-correct-env-in-tests.patch
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/534c122de166cb6464b489f3e6a9a544ceb1c913.patch";
      hash = "sha256-4q4LFsq4yU1xRwNsM1sJoNVphJCnxaVe2IyL6AeHJ/I=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/87598d4b63ef2c827a2bebdfa0f1540c35718519.patch";
      hash = "sha256-JJi8z9aaWnu/y3nZGOSUfeNzNSCYzD9dzoHXaGkeaEA=";
      includes = [ "test/common/assertSnapshot.js" ];
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/d0a6b605fba6cd69a82e6f12ff0363eef8fe1ee9.patch";
      hash = "sha256-TfYal/PikRZHL6zpAlC3SmkYXCe+/8Gs83dLX/X/P/k=";
    })
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
    # Fix for https://github.com/NixOS/nixpkgs/issues/355919
    # FIXME: remove after a minor point release
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/a094a8166cd772f89e92b5deef168e5e599fa815.patch?full_index=1";
      hash = "sha256-5FZfozYWRa1ZI/f+e+xpdn974Jg2DbiHbua13XUQP5E=";
    })
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/f270462c09ddfd770291a7c8a2cd204b2c63d730.patch?full_index=1";
      hash = "sha256-Err0i5g7WtXcnhykKgrS3ocX7/3oV9UrT0SNeRtMZNU=";
    })
  ] ++ gypPatches;
}
