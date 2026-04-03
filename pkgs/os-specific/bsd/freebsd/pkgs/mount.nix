{
  lib,
  mkDerivation,
  libutil,
  libxo,
}:
mkDerivation {
  path = "sbin/mount";
  buildInputs = [
    libutil
    libxo
  ];

  meta.platforms = lib.platforms.freebsd;
}
