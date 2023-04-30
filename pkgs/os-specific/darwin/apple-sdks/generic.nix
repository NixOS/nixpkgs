{
  lib,
  newScope,
  overrideCC,
  pkgs,
  stdenv,
  version,
}: let
  # TODO(@connorbaker): For some reason, building later MacOSX-SDK releases still requires the
  #   default SDK to have been built previously. Is this due to stdenv bootstrapping?
  majorMinorVersion = lib.versions.majorMinor version;
  apple_sdk_name = "apple_sdk_${builtins.replaceStrings ["."] ["_"] majorMinorVersion}";

  # mkCc = cc:
  #   if stdenv.isAarch64
  #   then cc
  #   else
  #     cc.override {
  #       bintools = stdenv.cc.bintools.override {libc = packages.Libsystem;};
  #       libc = packages.Libsystem;
  #     };

  mkCc = cc:
    cc.override {
      bintools = stdenv.cc.bintools.override {libc = packages.Libsystem;};
      libc = packages.Libsystem;
    };

  # mkStdenv = stdenv:
  #   if stdenv.isAarch64
  #   then stdenv
  #   else
  #     (overrideCC stdenv (mkCc stdenv.cc)).override {
  #       targetPlatform =
  #         stdenv.targetPlatform
  #         // {
  #           darwinMinVersion = "10.12";
  #           darwinSdkVersion = "11.0";
  #         };
  #     };

  mkStdenv = stdenv: let
    cc = overrideCC stdenv (mkCc stdenv.cc);
    darwinAttrs = {
      darwinMinVersion = "10.12";
      darwinSdkVersion = lib.versions.majorMinor packages.MacOSX-SDK.version;
    };
    targetPlatform = stdenv.targetPlatform // darwinAttrs;
  in
    cc.override {inherit targetPlatform;};

  stdenvs =
    {stdenv = mkStdenv stdenv;}
    // builtins.listToAttrs (
      builtins.map
      (v: lib.attrsets.nameValuePair "clang${v}Stdenv" (mkStdenv pkgs."llvmPackages_${v}".stdenv))
      ["12" "13" "14" "15"]
    );

  callPackage = newScope (packages // pkgs.darwin);

  packages =
    stdenvs
    // {
      # Make sure we pass our special `callPackage` instead of using packages.callPackage which
      # does not have necessary attributes in scope.
      frameworks = callPackage ./frameworks {inherit callPackage;};
      libs = callPackage ./libs {inherit callPackage;};

      MacOSX-SDK = callPackage ./CLTools_macOSNMOS_SDK.nix {inherit version;};
      CLTools_Executables = callPackage ./CLTools_Executables.nix {inherit version;};
      Libsystem = callPackage ./libSystem.nix {};
      LibsystemCross = pkgs.darwin.Libsystem;
      libcharset = callPackage ./libcharset.nix {};
      libunwind = callPackage ./libunwind.nix {};
      libnetwork = callPackage ./libnetwork.nix {};
      libpm = callPackage ./libpm.nix {};
      # Avoid introducing a new objc4 if stdenv already has one, to prevent
      # conflicting LLVM modules.
      objc4 = stdenv.objc4 or (callPackage ./libobjc.nix {});

      # TODO(@connorbaker): questionable aliases
      # TODO(@connorbaker): Why do we need to go through the pkgs.darwin.${apple_sdk_name}
      #   indirection?
      configd = pkgs.darwin.${apple_sdk_name}.frameworks.SystemConfiguration;
      inherit (pkgs.darwin.${apple_sdk_name}.frameworks) IOKit;

      xcodebuild = pkgs.xcbuild.override {
        inherit (pkgs.darwin.${apple_sdk_name}) stdenv;
        inherit (pkgs.darwin.${apple_sdk_name}.frameworks) CoreServices CoreGraphics ImageIO;
      };

      rustPlatform =
        pkgs.makeRustPlatform {
          inherit (pkgs.darwin.${apple_sdk_name}) stdenv;
          inherit (pkgs) rustc cargo;
        }
        // {
          inherit
            (pkgs.callPackage ../../../build-support/rust/hooks {
              inherit (pkgs.darwin.${apple_sdk_name}) stdenv;
              inherit (pkgs) cargo rustc;
              clang = mkCc pkgs.clang;
            })
            bindgenHook
            ;
        };

      # TODO(@connorbaker): Any reason we wouldn't want `libs` or `frameworks` to be in scope when
      #   using the `callPackage` belonging to a specific SDK?
      callPackage = newScope (lib.optionalAttrs stdenv.isDarwin (stdenvs
        // rec {
          inherit (pkgs.darwin.${apple_sdk_name}) xcodebuild rustPlatform;
          darwin = pkgs.darwin.overrideScope (_: prev: {
            inherit
              (prev.darwin.${apple_sdk_name})
              IOKit
              Libsystem
              LibsystemCross
              Security
              configd
              libcharset
              libunwind
              objc4
              ;
            apple_sdk = prev.darwin.${apple_sdk_name};
            CF = prev.darwin.${apple_sdk_name}.CoreFoundation;
          });
          xcbuild = xcodebuild;
        }));
    };
in
  packages
