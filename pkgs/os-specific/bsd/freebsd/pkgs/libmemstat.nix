{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
  libkvm,
  csu,
}:

mkDerivation {
  path = "lib/libmemstat";

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
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';
}
