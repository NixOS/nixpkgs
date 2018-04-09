{ pkgs, darwin, stdenv, callPackage, callPackages, newScope, runCommand, config }:

let
  apple-source-releases = callPackage ../os-specific/darwin/apple-source-releases { };
in

(apple-source-releases // {

  callPackage = newScope (darwin.apple_sdk.frameworks // darwin);

  apple_sdk = callPackage ../os-specific/darwin/apple-sdk { };

  binutils = pkgs.wrapBintoolsWith {
    libc =
      if pkgs.targetPlatform != pkgs.hostPlatform
      then pkgs.libcCross
      else pkgs.stdenv.cc.libc;
    bintools = callPackage ../os-specific/darwin/binutils {
      inherit (darwin) cctools;
    };
  };

  cctools = callPackage ../os-specific/darwin/cctools/port.nix {
    inherit (darwin) libobjc maloader;
    stdenv = if stdenv.isDarwin then stdenv else pkgs.libcxxStdenv;
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

  ios-cross = callPackage ../os-specific/darwin/ios-cross {
    inherit (darwin) binutils;
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

  codesign = drv: if builtins.hasAttr "keychain" config then
    (runCommand "codesign" {
      nativeBuildInputs = [
        apple-source-releases.security_systemkeychain
        darwin.cctools
        darwin.security_tool
      ];
    } ''
    IDENTITY=${config.keychain.identity}
    PASS=${config.keychain.password}
    export HOME=$PWD
    mkdir -p $PWD/Library/Keychains
    cp ${config.keychain.file} $PWD/Library/Keychains
    KEYCHAIN=$(basename $PWD/Library/Keychains/*)
    security unlock-keychain -p $PASS $KEYCHAIN
    security set-keychain-settings -u $PWD/Library/Keychains/$KEYCHAIN
    security find-identity -s codesigning $KEYCHAIN

    mkdir -p $out/bin
    for bin in ${drv}/bin/*; do
      cp $bin $out/bin
    done
    for bin in $out/bin/*; do
      codesign --sign $IDENTITY \
               --keychain $KEYCHAIN \
               $bin
    done

    security lock-keychain $KEYCHAIN
  '') else drv;
})
