{
  mkDerivation,
  include,
  libcompiler_rt,
  csu,
}:

mkDerivation {
  pname = "libsys";
  path = "lib/libsys";
  extraPaths = [
    "sys/sys"
    "lib/libc/string"
    "lib/libc/include"
    "lib/libc/Versions.def"
    "lib/libcompat"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];
  noLibc = true;

  buildInputs = [
    include
    csu
    libcompiler_rt
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I. -B${csu}/lib"
  '';

  alwaysKeepStatic = true;
}
