{
  lib,
  newScope,
  overrideCC,
  pkgs,
  stdenv,
  stdenvNoCC,
}:

let
  version = "12.3";

  MacOSX-SDK = callPackage ./CLTools_macOSNMOS_SDK.nix { inherit version; };
  callPackage = newScope (pkgs.darwin // packages);

  packages = {
    # Make sure we pass our special `callPackage` instead of using packages.callPackage which
    # does not have necessary attributes in scope.
    frameworks = callPackage ./frameworks { inherit callPackage; };
    libs = callPackage ./libs { inherit callPackage; };

    CLTools_Executables = callPackage ./CLTools_Executables.nix { inherit version; };
    Libsystem = callPackage ./libSystem.nix { };
    LibsystemCross = callPackage ./libSystem.nix { };
    libunwind = callPackage ./libunwind.nix { };
    libnetwork = callPackage ./libnetwork.nix { };
    libpm = callPackage ./libpm.nix { };
    # Avoid introducing a new objc4 if stdenv already has one, to prevent
    # conflicting LLVM modules.
    objc4 = stdenv.objc4 or (callPackage ./libobjc.nix { });

    darwin-stubs = stdenvNoCC.mkDerivation {
      pname = "darwin-stubs";
      inherit (MacOSX-SDK) version;

      preferLocalBuild = true;
      allowSubstitutes = false;

      buildCommand = ''
        mkdir -p "$out"
        ln -s ${MacOSX-SDK}/System "$out/System"
        ln -s ${MacOSX-SDK}/usr "$out/usr"
      '';
    };

    sdkRoot = pkgs.callPackage ../apple-sdk/sdkRoot.nix { sdkVersion = version; };
  };
in
packages
