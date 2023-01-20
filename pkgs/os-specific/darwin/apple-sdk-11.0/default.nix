{ stdenvNoCC, fetchurl, newScope, lib, pkgs
, stdenv, overrideCC
, xar, cpio, python3, pbzx }:

let
  MacOSX-SDK = stdenvNoCC.mkDerivation rec {
    pname = "MacOSX-SDK";
    version = "11.0.0";

    # https://swscan.apple.com/content/catalogs/others/index-11-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog
    src = fetchurl {
      url = "http://swcdn.apple.com/content/downloads/46/21/001-89745-A_56FM390IW5/v1um2qppgfdnam2e9cdqcqu2r6k8aa3lis/CLTools_macOSNMOS_SDK.pkg";
      sha256 = "0n425smj4q1vxbza8fzwnk323fyzbbq866q32w288c44hl5yhwsf";
    };

    dontBuild = true;
    darwinDontCodeSign = true;

    nativeBuildInputs = [ cpio pbzx ];

    outputs = [ "out" ];

    unpackPhase = ''
      pbzx $src | cpio -idm
    '';

    installPhase = ''
      cd Library/Developer/CommandLineTools/SDKs/MacOSX11.1.sdk

      mkdir $out
      cp -r System usr $out/
    '';

    passthru = {
      inherit version;
    };
  };

  callPackage = newScope (packages // pkgs.darwin // { inherit MacOSX-SDK; });

  packages = {
    inherit (callPackage ./apple_sdk.nix {}) frameworks libs;

    # TODO: this is nice to be private. is it worth the callPackage above?
    # Probably, I don't think that callPackage costs much at all.
    inherit MacOSX-SDK;

    Libsystem = callPackage ./libSystem.nix {};
    LibsystemCross = pkgs.darwin.Libsystem;
    libcharset = callPackage ./libcharset.nix {};
    libunwind = callPackage ./libunwind.nix {};
    libnetwork = callPackage ./libnetwork.nix {};
    objc4 = callPackage ./libobjc.nix {};

    # questionable aliases
    configd = pkgs.darwin.apple_sdk.frameworks.SystemConfiguration;
    IOKit = pkgs.darwin.apple_sdk.frameworks.IOKit;

    callPackage = newScope (lib.optionalAttrs stdenv.isDarwin rec {
      inherit (pkgs.darwin.apple_sdk_11_0) stdenv;
      darwin = pkgs.darwin.overrideScope (_: prev: {
        inherit (prev.darwin.apple_sdk_11_0) Libsystem LibsystemCross libcharset libunwind objc4 configd IOKit Security;
        apple_sdk = prev.darwin.apple_sdk_11_0;
        CF = prev.darwin.apple_sdk_11_0.CoreFoundation;
      });
      xcodebuild = pkgs.xcbuild.override {
        inherit (pkgs.darwin.apple_sdk_11_0.frameworks) CoreServices CoreGraphics ImageIO;
        inherit stdenv;
      };
      xcbuild = xcodebuild;
    });

    stdenv =
      let
        clang = stdenv.cc.override {
          bintools = stdenv.cc.bintools.override { libc = packages.Libsystem; };
          libc = packages.Libsystem;
        };
      in
      if stdenv.isAarch64 then stdenv
      else
        (overrideCC stdenv clang).override {
          targetPlatform = stdenv.targetPlatform // {
            darwinMinVersion = "10.12";
            darwinSdkVersion = "11.0";
          };
        };
  };
in packages
