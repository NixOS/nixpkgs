{
  lib,
  stdenv,
  mkDerivation,
  libnv,
}:
mkDerivation {
  path = "lib/libcasper/libcasper";
  extraPaths = [
    "lib/Makefile.inc"
    "lib/libcasper"
  ];
  buildInputs = [ libnv ];

  MK_TESTS = "no";

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "CFLAGS=-DWITH_CASPER"
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";

  postInstall = ''
    make -C $BSDSRCDIR/lib/libcasper/services $makeFlags CFLAGS="-DWITH_CASPER -I$out/include"
    make -C $BSDSRCDIR/lib/libcasper/services $makeFlags install
  '';
}
