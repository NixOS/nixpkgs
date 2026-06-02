{
  mkDerivation,
  include,
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
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I. -B${csu}/lib"
  '';

  alwaysKeepStatic = true;
}
