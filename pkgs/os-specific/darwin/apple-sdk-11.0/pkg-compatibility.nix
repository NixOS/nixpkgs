{ darwinPackages
, lib
, pkgs
, stdenv
}:

# Provides overriden stdenv and gccStdenvs plus a callPackage with additional packages that have
# been overriden to use this SDK instead of the standard one for the target Darwin architecture.
# This is set up so it should default to the standard stdenv and package environment on non-Darwin
# platforms. On platforms where this SDK is the default, it should also pass through.
let
  needsOverrides = stdenv.isDarwin && stdenv.isx86_64;

  overrideDarwinVersion = platform: darwinMinVersion: darwinSdkVersion: platform // {
    inherit darwinMinVersion darwinSdkVersion;
  };

  overridePlatformDarwinVersions = stdenv: darwinMinVersion: darwinSdkVersion: stdenv.override {
    buildPlatform = overrideDarwinVersion stdenv.buildPlatform darwinMinVersion darwinSdkVersion;
    hostPlatform = overrideDarwinVersion stdenv.hostPlatform darwinMinVersion darwinSdkVersion;
    targetPlatform = overrideDarwinVersion stdenv.targetPlatform darwinMinVersion darwinSdkVersion;
  };

  nixpkgsFun = newArgs: import ./../../../.. (pkgs // newArgs);

  sdkPkgs =
    if !needsOverrides then pkgs
    else
      nixpkgsFun {
        overlays = [
          (_: _: {
            inherit (darwinPackages) stdenv;
            darwin = pkgs.darwin.overrideScope (_: prev: {
              inherit (prev.apple_sdk_11_0) Libsystem LibsystemCross libcharset libunwind objc4 configd IOKit Security;
              apple_sdk = prev.apple_sdk_11_0;
              CF = prev.apple_sdk_11_0.CoreFoundation;
            });
          })
        ];
      };
in
{
  callPackage =
    pkgs.newScope (lib.optionalAttrs needsOverrides {
      inherit (sdkPkgs) gccStdenv gcc10Stdenv gcc11Stdenv rustPlatform darwin xcbuild xcodebuild;
      inherit (darwinPackages) stdenv;
    });

  inherit (sdkPkgs) gccStdenv gcc10StdenvCompat gcc11Stdenv;

  stdenv =
    let
      clang = stdenv.cc.override rec {
        bintools = stdenv.cc.bintools.override { inherit libc; };
        libc = darwinPackages.Libsystem;
      };
    in
    if !needsOverrides then stdenv
    else overridePlatformDarwinVersions (pkgs.overrideCC stdenv clang) "10.12" "11.0";
}
