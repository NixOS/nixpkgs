{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.sbin/vidcontrol";

  meta.mainProgram = "vidcontrol";
  meta.platforms = lib.platforms.freebsd;
}
