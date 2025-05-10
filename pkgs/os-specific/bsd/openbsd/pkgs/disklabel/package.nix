{
  lib,
  mkDerivation,
  mandoc,
}:
mkDerivation {
  path = "sbin/disklabel";
  extraNativeBuildInputs = [
    mandoc
  ];
  meta.platforms = lib.platforms.openbsd;
  meta.mainProgram = "disklabel";
}
