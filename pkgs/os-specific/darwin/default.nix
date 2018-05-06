{ buildPackages, pkgs, targetPackages
, darwin, stdenv, callPackage, callPackages, newScope
}:

let
  apple-source-releases = callPackage ./apple-source-releases { };
in

(apple-source-releases // {

  callPackage = newScope (darwin.apple_sdk.frameworks // darwin);

  apple_sdk = callPackage ./apple-sdk { };

  binutils-unwrapped = callPackage ./binutils {
    inherit (darwin) cctools;
    inherit (pkgs) binutils-unwrapped;
  };

  binutils = pkgs.wrapBintoolsWith {
    libc =
      if pkgs.targetPlatform != pkgs.hostPlatform
      then pkgs.libcCross
      else pkgs.stdenv.cc.libc;
    bintools = darwin.binutils-unwrapped;
  };

  cctools = callPackage ./cctools/port.nix {
    inherit (darwin) libobjc maloader;
    stdenv = if stdenv.isDarwin then stdenv else pkgs.libcxxStdenv;
    libcxxabi = pkgs.libcxxabi;
    xctoolchain = darwin.xcode.toolchain;
  };

  cf-private = callPackage ./cf-private {
    inherit (apple-source-releases) CF;
    inherit (darwin) osx_private_sdk;
  };

  DarwinTools = callPackage ./DarwinTools { };

  maloader = callPackage ./maloader {
    inherit (darwin) opencflite;
  };

  insert_dylib = callPackage ./insert_dylib { };

  iosSdkPkgs = darwin.callPackage ./ios-sdk-pkgs {
    buildIosSdk = buildPackages.darwin.iosSdkPkgs.sdk;
    targetIosSdkPkgs = targetPackages.darwin.iosSdkPkgs;
    inherit (pkgs.llvmPackages) clang-unwrapped;
  };

  libobjc = apple-source-releases.objc4;

  lsusb = callPackage ./lsusb { };

  opencflite = callPackage ./opencflite { };

  osx_private_sdk = callPackage ./osx-private-sdk { };

  security_tool = darwin.callPackage ./security-tool {
    Security-framework = darwin.apple_sdk.frameworks.Security;
  };

  stubs = callPackages ./stubs { };

  trash = callPackage ./trash { inherit (darwin.apple_sdk) frameworks; };

  usr-include = callPackage ./usr-include { };

  xcode = callPackage ./xcode { };

  CoreSymbolication = callPackage ./CoreSymbolication { };

  swift-corelibs = callPackages ./swift-corelibs { };

  darling = callPackage ./darling/default.nix { };

  duti = callPackage ./duti {};

  ghc-standalone-archive = callPackage ./ghc-standalone-archive { inherit (darwin) cctools; };

  qes = callPackage ./qes {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  reattach-to-user-namespace = callPackage ./reattach-to-user-namespace {};

  skhd = callPackage ./skhd {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  kwm = callPackage ./kwm { };

  khd = callPackage ./khd {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

})
