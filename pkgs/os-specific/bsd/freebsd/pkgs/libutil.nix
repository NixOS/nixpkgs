{
  lib,
  mkDerivation,
  include,
  libgcc,
  libcMinimal,
  csu,
  withPwdMkdb ? null,
}:
mkDerivation {
  path = "lib/libutil";
  extraPaths = [
    "lib/libc/gen"
    "lib/libc/Versions.def"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    include
    libgcc
    libcMinimal
  ];

  # XXX mass rebuild moment
  postPatch =
    if withPwdMkdb == null then
      null
    else
      ''
        substituteInPlace lib/libutil/pw_util.c --replace-fail _PATH_PWD_MKDB '"${lib.getExe withPwdMkdb}"'
      '';

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
