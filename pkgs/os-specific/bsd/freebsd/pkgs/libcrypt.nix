{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
<<<<<<< HEAD
  libmd,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  csu,
}:

mkDerivation {
  path = "lib/libcrypt";
  extraPaths = [
    "sys/kern"
    "sys/crypto"
    "lib/libmd"
    "secure/lib/libcrypt"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    include
    libcMinimal
    libgcc
<<<<<<< HEAD
    libmd
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
