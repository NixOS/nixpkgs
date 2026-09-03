{
  lib,
  mkDerivation,
  mandoc,
}:
mkDerivation {
  path = "sbin/fdisk";
  extraNativeBuildInputs = [ mandoc ];
  meta.mainProgram = "fdisk";
  meta.platforms = lib.platforms.openbsd;
}
