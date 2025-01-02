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
  version = "20.18.1";
  sha256 = "91df43f8ab6c3f7be81522d73313dbdd5634bbca228ef0e6d9369fe0ab8cccd0";
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
    # fixes test failure, remove when included in release
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/b6fe731c55eb4cb9d14042a23e5002ed39b7c8b7.patch?full_index=1";
      hash = "sha256-KoKsQBFKUji0GeEPTR8ixBflCiHBhPqd2cPVPuKyua8=";
    })
  ] ++ gypPatches;
}
