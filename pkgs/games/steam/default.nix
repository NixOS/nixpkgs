{ lib, newScope, splicePackages, steamPackagesAttr ? "steamPackages"
, pkgsBuildBuild, pkgsBuildHost, pkgsBuildTarget, pkgsHostHost, pkgsTargetTarget
, stdenv, buildFHSUserEnv, pkgsi686Linux
}:

let
  steamPackagesFun = self: let
    inherit (self) callPackage;
  in {
    steamArch = if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
                else if stdenv.hostPlatform.system == "i686-linux" then "i386"
                else throw "Unsupported platform: ${stdenv.hostPlatform.system}";

    steam-runtime = callPackage ./runtime.nix { };
    steam-runtime-wrapped = callPackage ./runtime-wrapped.nix { };
    steam = callPackage ./steam.nix { };
    steam-fhsenv = callPackage ./fhsenv.nix {
      glxinfo-i686 = pkgsi686Linux.glxinfo;
      steam-runtime-wrapped-i686 =
        if self.steamArch == "amd64"
        then pkgsi686Linux.${steamPackagesAttr}.steam-runtime-wrapped
        else null;
      inherit buildFHSUserEnv;
    };
    steamcmd = callPackage ./steamcmd.nix { };
  };
  otherSplices = {
    selfBuildBuild = pkgsBuildBuild.${steamPackagesAttr};
    selfBuildHost = pkgsBuildHost.${steamPackagesAttr};
    selfBuildTarget = pkgsBuildTarget.${steamPackagesAttr};
    selfHostHost = pkgsHostHost.${steamPackagesAttr};
    selfTargetTarget = pkgsTargetTarget.${steamPackagesAttr} or {}; # might be missing;
  };
  keep = self: { };
  extra = spliced0: { };
in lib.makeScopeWithSplicing splicePackages newScope otherSplices keep extra steamPackagesFun
