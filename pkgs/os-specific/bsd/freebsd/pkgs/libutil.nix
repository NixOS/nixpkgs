{
<<<<<<< HEAD
  lib,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mkDerivation,
  include,
  libgcc,
  libcMinimal,
  csu,
<<<<<<< HEAD
  withPwdMkdb ? null,
}:
mkDerivation {
  path = "lib/libutil";
  extraPaths = [
    "lib/libc/gen"
    "lib/libc/Versions.def"
  ];
=======
}:
mkDerivation {
  path = "lib/libutil";
  extraPaths = [ "lib/libc/gen" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  # XXX mass rebuild moment
  postPatch =
    if withPwdMkdb == null then
      null
    else
      ''
        substituteInPlace lib/libutil/pw_util.c --replace-fail _PATH_PWD_MKDB '"${lib.getExe withPwdMkdb}"'
      '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
