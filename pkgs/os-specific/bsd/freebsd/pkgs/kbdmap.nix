{
  lib,
  mkDerivation,
  libbsddialog,
}:
mkDerivation {
  path = "usr.sbin/kbdmap";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  buildInputs = [
    libbsddialog
  ];

  meta.mainProgram = "kbdmap";
  meta.platforms = lib.platforms.freebsd;
}
