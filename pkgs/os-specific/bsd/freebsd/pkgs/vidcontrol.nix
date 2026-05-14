{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.sbin/vidcontrol";

  meta.mainProgram = "vidcontrol";
  meta.platorms = lib.platforms.freebsd;
}
