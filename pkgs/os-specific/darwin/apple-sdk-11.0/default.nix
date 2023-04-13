{ stdenvNoCC, fetchurl, newScope, lib, pkgs
, stdenv, overrideCC
, xar, cpio, python3, pbzx }:

let
  mkSusDerivation = args: stdenvNoCC.mkDerivation (args // {
    dontBuild = true;
    darwinDontCodeSign = true;

    nativeBuildInputs = [ cpio pbzx ];

    outputs = [ "out" ];

    unpackPhase = ''
      pbzx $src | cpio -idm
    '';

    passthru = {
      inherit (args) version;
    };
  });

  MacOSX-SDK = mkSusDerivation {
    pname = "MacOSX-SDK";
    version = "11.0.0";

    # https://swscan.apple.com/content/catalogs/others/index-11-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog
    src = fetchurl {
      url = "http://swcdn.apple.com/content/downloads/46/21/001-89745-A_56FM390IW5/v1um2qppgfdnam2e9cdqcqu2r6k8aa3lis/CLTools_macOSNMOS_SDK.pkg";
      sha256 = "0n425smj4q1vxbza8fzwnk323fyzbbq866q32w288c44hl5yhwsf";
    };

    installPhase = ''
      mv Library/Developer/CommandLineTools/SDKs/MacOSX11.1.sdk $out
    '';
  };

  CLTools_Executables = mkSusDerivation {
    pname = "CLTools_Executables";
    version = "11.0.0";

    # https://swscan.apple.com/content/catalogs/others/index-11-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog
    src = fetchurl {
      url = "http://swcdn.apple.com/content/downloads/46/21/001-89745-A_56FM390IW5/v1um2qppgfdnam2e9cdqcqu2r6k8aa3lis/CLTools_Executables.pkg";
      sha256 = "0nvb1qx7l81l2wcl8wvgbpsg5rcn51ylhivqmlfr2hrrv3zrrpl0";
    };

    installPhase = ''
      mv Library/Developer/CommandLineTools $out
    '';
  };

  mkStdenv = stdenv:
    let
      cc = stdenv.cc.override {
        bintools = stdenv.cc.bintools.override { libc = packages.Libsystem; };
        libc = packages.Libsystem;
      };
    in
    if stdenv.isAarch64 then stdenv
    else
      (overrideCC stdenv cc).override {
        targetPlatform = stdenv.targetPlatform // {
          darwinMinVersion = "10.12";
          darwinSdkVersion = "11.0";
        };
      };

  stdenvs = {
    stdenv = mkStdenv stdenv;
  } // builtins.listToAttrs (map
    (v: { name = "clang${v}Stdenv"; value = mkStdenv pkgs."llvmPackages_${v}".stdenv; })
    [ "12" "13" "14" "15" ]
  );

  callPackage = newScope (packages // pkgs.darwin // { inherit MacOSX-SDK; });

  packages = stdenvs // {
    inherit (callPackage ./apple_sdk.nix { }) frameworks libs;

    # TODO: this is nice to be private. is it worth the callPackage above?
    # Probably, I don't think that callPackage costs much at all.
    inherit MacOSX-SDK CLTools_Executables;

    Libsystem = callPackage ./libSystem.nix { };
    LibsystemCross = pkgs.darwin.Libsystem;
    libcharset = callPackage ./libcharset.nix { };
    libunwind = callPackage ./libunwind.nix { };
    libnetwork = callPackage ./libnetwork.nix { };
    libpm = callPackage ./libpm.nix { };
    # Avoid introducing a new objc4 if stdenv already has one, to prevent
    # conflicting LLVM modules.
    objc4 = stdenv.objc4 or (callPackage ./libobjc.nix { });

    # questionable aliases
    configd = pkgs.darwin.apple_sdk.frameworks.SystemConfiguration;
    inherit (pkgs.darwin.apple_sdk.frameworks) IOKit;

    xcodebuild = pkgs.xcbuild.override {
      inherit (pkgs.darwin.apple_sdk_11_0) stdenv;
      inherit (pkgs.darwin.apple_sdk_11_0.frameworks) CoreServices CoreGraphics ImageIO;
    };

    rustPlatform = pkgs.makeRustPlatform {
      inherit (pkgs.darwin.apple_sdk_11_0) stdenv;
      inherit (pkgs) rustc cargo;
    };

    callPackage = newScope (lib.optionalAttrs stdenv.isDarwin (stdenvs // rec {
      inherit (pkgs.darwin.apple_sdk_11_0) xcodebuild rustPlatform;
      darwin = pkgs.darwin.overrideScope (_: prev: {
        inherit (prev.darwin.apple_sdk_11_0)
          IOKit
          Libsystem
          LibsystemCross
          Security
          configd
          libcharset
          libunwind
          objc4
          ;
        apple_sdk = prev.darwin.apple_sdk_11_0;
        CF = prev.darwin.apple_sdk_11_0.CoreFoundation;
      });
      xcbuild = xcodebuild;
    }));
  };
in packages
