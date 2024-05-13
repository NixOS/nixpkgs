{ lib, mkDerivation }:

mkDerivation (
  import ./base.nix
  // {
    pname = "libpthread-headers";
    installPhase = "includesPhase";
    dontBuild = true;
    noCC = true;
    meta.platforms = lib.platforms.netbsd;
  }
)
