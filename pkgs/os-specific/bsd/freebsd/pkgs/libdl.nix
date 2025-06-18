{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
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
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';
}
