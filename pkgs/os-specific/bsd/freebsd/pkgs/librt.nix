{
  mkDerivation,
  include,
  libcMinimal,
<<<<<<< HEAD
  libsys,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libgcc,
  libthr,
  csu,
}:

mkDerivation {
  path = "lib/librt";
  extraPaths = [
    "lib/libc/include" # private headers
    "lib/libc/Versions.def"
  ];

  outputs = [
    "out"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    include
    libcMinimal
    libgcc
    libthr
<<<<<<< HEAD
    libsys
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
