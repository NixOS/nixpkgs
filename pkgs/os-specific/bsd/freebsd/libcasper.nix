{ lib, stdenv, mkDerivation, libc, libnv, ...}:
mkDerivation {
  path = "lib/libcasper/libcasper";
  buildInputs = [libc libnv];

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "CFLAGS=-DWITH_CASPER"
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";
}
