{
  mkDerivation,
  include,
  libcMinimal,
  libgcc,
  csu,
}:

mkDerivation {
  path = "lib/libiconv_modules";
  extraPaths = [
    "lib/libc/iconv"
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
    export makeFlags="$makeFlags SHLIBDIR=$out/lib/i18n"
  '';
}
