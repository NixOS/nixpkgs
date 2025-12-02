{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
  csu,
}:

mkDerivation {
  path = "lib/msun";
  extraPaths = [
    "lib/libc" # wants arch headers
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
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
