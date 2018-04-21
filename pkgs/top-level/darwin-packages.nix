{ buildPackages, pkgs, targetPackages
, darwin, stdenv, callPackage, callPackages, newScope
}:

let
  apple-source-releases = callPackage ../os-specific/darwin/apple-source-releases { };
in

(apple-source-releases // {

  callPackage = newScope (darwin.apple_sdk.frameworks // darwin);

  apple_sdk = callPackage ../os-specific/darwin/apple-sdk { };

  binutils-unwrapped = callPackage ../os-specific/darwin/binutils {
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

  cctools = callPackage ../os-specific/darwin/cctools/port.nix {
    inherit (darwin) libobjc maloader;
    stdenv = if stdenv.isDarwin then stdenv else pkgs.libcxxStdenv;
    libcxxabi = pkgs.libcxxabi;
    xctoolchain = darwin.xcode.toolchain;
  };

  cf-private = callPackage ../os-specific/darwin/cf-private {
    inherit (apple-source-releases) CF;
    inherit (darwin) osx_private_sdk;
  };

  DarwinTools = callPackage ../os-specific/darwin/DarwinTools { };

  maloader = callPackage ../os-specific/darwin/maloader {
    inherit (darwin) opencflite;
  };

  insert_dylib = callPackage ../os-specific/darwin/insert_dylib { };

  iosSdkPkgs = darwin.callPackage ../os-specific/darwin/ios-sdk-pkgs {
    buildIosSdk = buildPackages.darwin.iosSdkPkgs.sdk;
    targetIosSdkPkgs = targetPackages.darwin.iosSdkPkgs;
    inherit (pkgs.llvmPackages) clang-unwrapped;
  };

  libobjc = apple-source-releases.objc4;
  
  lsusb = callPackage ../os-specific/darwin/lsusb { };

  opencflite = callPackage ../os-specific/darwin/opencflite { };

  osx_private_sdk = callPackage ../os-specific/darwin/osx-private-sdk { };

  security_tool = darwin.callPackage ../os-specific/darwin/security-tool {
    Security-framework = darwin.apple_sdk.frameworks.Security;
  };

  stubs = callPackages ../os-specific/darwin/stubs { };

  trash = callPackage ../os-specific/darwin/trash { inherit (darwin.apple_sdk) frameworks; };

  usr-include = callPackage ../os-specific/darwin/usr-include { };

  xcode = callPackage ../os-specific/darwin/xcode { };

  CoreSymbolication = callPackage ../os-specific/darwin/CoreSymbolication { };

  swift-corelibs = callPackages ../os-specific/darwin/swift-corelibs { };

  darling = callPackage ../os-specific/darwin/darling/default.nix { };

})
