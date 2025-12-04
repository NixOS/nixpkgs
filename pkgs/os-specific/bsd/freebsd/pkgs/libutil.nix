{
  mkDerivation,
  include,
  libgcc,
  libcMinimal,
  csu,
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

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
