{
  mkDerivation,
  include,
  libelf,
  libcMinimal,
  libgcc,
  csu,
}:

mkDerivation {
  path = "lib/libexecinfo";
  extraPaths = [
    "contrib/libexecinfo"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    include
    libelf
    libcMinimal
    libgcc
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}
