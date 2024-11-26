{
  stdenv,
  mkDerivation,
  byacc,
  flex,
}:

mkDerivation {
  path = "usr.bin/mkesdb";

  extraPaths = [ "lib/libc/iconv" ];

  BOOTSTRAPPING = !stdenv.hostPlatform.isFreeBSD;

  extraNativeBuildInputs = [
    byacc
    flex
  ];
}
