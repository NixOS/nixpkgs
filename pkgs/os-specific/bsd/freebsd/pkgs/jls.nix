{
  lib,
  mkDerivation,
  libjail,
  libxo,
}:
mkDerivation {
  path = "usr.sbin/jls";
  buildInputs = [
    libjail
    libxo
  ];
  meta.mainProgram = "jls";
  meta.platforms = lib.platforms.freebsd;
}
