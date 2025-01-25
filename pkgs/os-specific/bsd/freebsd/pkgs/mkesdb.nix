{
  mkDerivation,
  byacc,
  flex,
}:

mkDerivation {
  path = "usr.bin/mkesdb";

  extraPaths = [ "lib/libc/iconv" ];

  extraNativeBuildInputs = [
    byacc
    flex
  ];
}
