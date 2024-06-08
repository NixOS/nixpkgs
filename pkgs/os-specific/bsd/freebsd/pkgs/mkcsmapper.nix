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

  BOOTSTRAPPING = !stdenv.hostPlatform.isFreeBSD;

  extraNativeBuildInputs = [
    byacc
    flex
  ];
}
