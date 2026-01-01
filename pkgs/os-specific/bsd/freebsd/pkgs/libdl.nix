{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
<<<<<<< HEAD
  libsys,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  csu,
}:

mkDerivation {
  path = "lib/libdl";
  extraPaths = [
    "libexec/rtld-elf"
    "lib/libc/gen"
    "lib/libc/include"
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
<<<<<<< HEAD
    libsys
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';
}
