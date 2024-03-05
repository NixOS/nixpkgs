{ makeScopeWithSplicing', generateSplicesForMkScope
, stdenv, buildFHSEnv, pkgsi686Linux, glxinfo
}:

let
  steamPackagesFun = self: let
    inherit (self) callPackage;
  in rec {
    steamArch = if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
                else if stdenv.hostPlatform.system == "i686-linux" then "i386"
                else throw "Unsupported platform: ${stdenv.hostPlatform.system}";

    steam-runtime = callPackage ./runtime.nix { };
    steam-runtime-wrapped = callPackage ./runtime-wrapped.nix { };
    steam = callPackage ./steam.nix { };
    steam-fhsenv = callPackage ./fhsenv.nix {
      glxinfo-i686 =
        if self.steamArch == "amd64"
        then pkgsi686Linux.glxinfo
        else glxinfo;
      steam-runtime-wrapped-i686 =
        if self.steamArch == "amd64"
        then pkgsi686Linux.steamPackages.steam-runtime-wrapped
        else null;
      inherit buildFHSEnv;
    };
    steam-fhsenv-small = steam-fhsenv.override { withGameSpecificLibraries = false; };

    # This has to exist so Hydra tries to build all of Steam's dependencies.
    # FIXME: Maybe we should expose it as something more generic?
    steam-fhsenv-without-steam = steam-fhsenv.override { steam = null; };

    steamcmd = callPackage ./steamcmd.nix { };
  };
in makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "steamPackages";
  f = steamPackagesFun;
}
