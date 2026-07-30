{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
  libelf,
  csu,
}:

mkDerivation {
  path = "lib/libkvm";
  extraPaths = [
    "sys" # wants sys/${arch}
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
    libelf
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
