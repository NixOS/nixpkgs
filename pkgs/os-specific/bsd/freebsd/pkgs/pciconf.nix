{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.sbin/pciconf";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta.platorms = lib.platforms.freebsd;
  meta.mainProgram = "pciconf";
}
