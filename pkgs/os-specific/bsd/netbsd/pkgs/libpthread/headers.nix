{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libpthread";
  pname = "libpthread-headers";
  installPhase = "runHook preInstall; includesPhase; runHook postInstall";
  dontBuild = true;
  noCC = true;
  meta.platforms = lib.platforms.netbsd;
}
