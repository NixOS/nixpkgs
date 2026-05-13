{
  mkDerivation,
  lib,
  libcasper,
  libcapsicum,
  libipsec,
}:
mkDerivation {
  path = "sbin/ping";
  buildInputs = [
    libcasper
    libcapsicum
    libipsec
  ];

  postPatch = ''
    sed -i 's/4555/0555/' $BSDSRCDIR/sbin/ping/Makefile
  '';

  MK_TESTS = "no";
  clangFixup = true;

  meta.platforms = lib.platforms.freebsd;
}
