{ lib, stdenv, mkDerivation, libc, libnv, ...}:
mkDerivation {
  path = "lib/libcasper";
  extraPaths = ["lib/Makefile.inc"];
  buildInputs = [libnv];

  MK_TESTS = "no";

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "CFLAGS=-DWITH_CASPER"
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";
}
