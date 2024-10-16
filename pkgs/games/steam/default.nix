{ makeScopeWithSplicing', generateSplicesForMkScope
, stdenv
}:

let
  steamPackagesFun = self: let
    inherit (self) callPackage;
  in rec {
    steamArch = if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
                else if stdenv.hostPlatform.system == "i686-linux" then "i386"
                else throw "Unsupported platform: ${stdenv.hostPlatform.system}";

    steam = callPackage ./steam.nix { };
    steam-fhsenv = callPackage ./fhsenv.nix {};

    # This has to exist so Hydra tries to build all of Steam's dependencies.
    # FIXME: Maybe we should expose it as something more generic?
    steam-fhsenv-without-steam = steam-fhsenv.override { steam = null; };

    steamcmd = callPackage ./steamcmd.nix { };
  };
in makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "steamPackages";
  f = steamPackagesFun;
}
