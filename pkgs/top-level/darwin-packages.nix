{ lib
, buildPackages, pkgs, targetPackages
, pkgsBuildBuild, pkgsBuildHost, pkgsBuildTarget, pkgsHostHost, pkgsTargetTarget
, stdenv, splicePackages, newScope
}:

let
  otherSplices = {
    selfBuildBuild = pkgsBuildBuild.darwin;
    selfBuildHost = pkgsBuildHost.darwin;
    selfBuildTarget = pkgsBuildTarget.darwin;
    selfHostHost = pkgsHostHost.darwin;
    selfTargetTarget = pkgsTargetTarget.darwin or {}; # might be missing
  };

in

lib.makeScopeWithSplicing splicePackages newScope otherSplices (_: {}) (spliced: spliced.apple_sdk.frameworks) (self: let
  inherit (self) mkDerivation callPackage;

  # Must use pkgs.callPackage to avoid infinite recursion.

  apple-source-releases = pkgs.callPackage ../os-specific/darwin/apple-source-releases { } self;

  impure-cmds = pkgs.callPackage ../os-specific/darwin/impure-cmds { };

  apple_sdk = pkgs.callPackage ../os-specific/darwin/apple-sdk {
    inherit (buildPackages.darwin) print-reexports;
    inherit (self) darwin-stubs;
  };
in

impure-cmds // apple-source-releases // {

  inherit apple_sdk;

  stdenvNoCF = stdenv.override {
    extraBuildInputs = [];
  };

  binutils-unwrapped = callPackage ../os-specific/darwin/binutils {
    inherit (pkgs) binutils-unwrapped;
    inherit (pkgs.llvmPackages_7) llvm clang-unwrapped;
  };

  binutils = pkgs.wrapBintoolsWith {
    libc =
      if stdenv.targetPlatform != stdenv.hostPlatform
      then pkgs.libcCross
      else pkgs.stdenv.cc.libc;
    bintools = self.binutils-unwrapped;
  };

  binutilsNoLibc = pkgs.wrapBintoolsWith {
    libc = null;
    bintools = self.binutils-unwrapped;
  };

  cctools = callPackage ../os-specific/darwin/cctools/port.nix {
    stdenv = if stdenv.isDarwin then stdenv else pkgs.libcxxStdenv;
    libcxxabi = pkgs.libcxxabi;
  };

  # TODO: remove alias.
  cf-private = self.apple_sdk.frameworks.CoreFoundation;

  DarwinTools = callPackage ../os-specific/darwin/DarwinTools { };

  darwin-stubs = callPackage ../os-specific/darwin/darwin-stubs { };

  print-reexports = callPackage ../os-specific/darwin/apple-sdk/print-reexports { };

  maloader = callPackage ../os-specific/darwin/maloader {
  };

  insert_dylib = callPackage ../os-specific/darwin/insert_dylib { };

  iosSdkPkgs = callPackage ../os-specific/darwin/xcode/sdk-pkgs.nix {
    buildIosSdk = buildPackages.darwin.iosSdkPkgs.sdk;
    targetIosSdkPkgs = targetPackages.darwin.iosSdkPkgs;
    inherit (pkgs.llvmPackages) clang-unwrapped;
  };

  iproute2mac = callPackage ../os-specific/darwin/iproute2mac { };

  libobjc = apple-source-releases.objc4;

  lsusb = callPackage ../os-specific/darwin/lsusb { };

  opencflite = callPackage ../os-specific/darwin/opencflite { };

  stubs = pkgs.callPackages ../os-specific/darwin/stubs { };

  trash = callPackage ../os-specific/darwin/trash { };

  usr-include = callPackage ../os-specific/darwin/usr-include { };

  inherit (pkgs.callPackages ../os-specific/darwin/xcode { })
    xcode_8_1 xcode_8_2
    xcode_9_1 xcode_9_2 xcode_9_4 xcode_9_4_1
    xcode_10_2 xcode_10_2_1 xcode_10_3
    xcode_11
    xcode;

  CoreSymbolication = callPackage ../os-specific/darwin/CoreSymbolication { };

  CF = callPackage ../os-specific/darwin/swift-corelibs/corefoundation.nix { };

  # As the name says, this is broken, but I don't want to lose it since it's a direction we want to go in
  # libdispatch-broken = callPackage ../os-specific/darwin/swift-corelibs/libdispatch.nix { };

  darling = callPackage ../os-specific/darwin/darling/default.nix { };

  libtapi = callPackage ../os-specific/darwin/libtapi {};

  ios-deploy = callPackage ../os-specific/darwin/ios-deploy {};

  discrete-scroll = callPackage ../os-specific/darwin/discrete-scroll { };

})
