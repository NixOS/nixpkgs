{
  stdenv,
  mkDerivation,
  byacc,
  flex,
}:

mkDerivation {
  path = "usr.bin/mkcsmapper";

  extraPaths = [
    "lib/libc/iconv"
    "lib/libiconv_modules/mapper_std"
  ];

  extraNativeBuildInputs = [
    byacc
    flex
  ];
}
