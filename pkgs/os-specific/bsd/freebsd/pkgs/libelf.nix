{
  lib,
  stdenv,
  mkDerivation,
  m4,
  include,
  libcMinimal,
  libgcc,
  compatIfNeeded,
  csu,
}:

mkDerivation {
  path = "lib/libelf";
  extraPaths = [
    "lib/libc"
    "contrib/elftoolchain"
    "sys/sys"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  noLibc = stdenv.hostPlatform.isFreeBSD;

  buildInputs =
    lib.optionals stdenv.hostPlatform.isFreeBSD [
      include
      libcMinimal
      libgcc
    ]
    ++ compatIfNeeded;

  extraNativeBuildInputs = [
    m4
  ];

  preBuild = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';
}
