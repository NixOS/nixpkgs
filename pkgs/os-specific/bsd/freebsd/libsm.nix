{ mkDerivation, lib, stdenv, ...}:
mkDerivation {
  path = "lib/libsm";
  extraPaths = ["contrib/sendmail"];
  postPatch = ''
    sed -E -i -e '/^INTERNALLIB.*/d' $BSDSRCDIR/lib/libsm/Makefile
  '';
  clangFixup = true;
  MK_TESTS = "no";
}
