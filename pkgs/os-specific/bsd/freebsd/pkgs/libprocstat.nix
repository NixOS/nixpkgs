{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
  libkvm,
  libutil,
  libelf,
  csu,
  extraSrc ? [ ],
}:

mkDerivation {
  path = "lib/libprocstat";
  extraPaths = [
    "lib/libc/Versions.def"
    "sys/contrib/openzfs"
    "sys/contrib/pcg-c"
    "sys/opencrypto"
    "sys/crypto"
<<<<<<< HEAD
    "sys/modules/zfs"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ extraSrc;

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
    libkvm
    libutil
    libelf
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';
}
