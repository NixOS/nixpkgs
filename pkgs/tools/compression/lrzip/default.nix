{stdenv, fetchurl, zlib, lzo, bzip2, nasm}:

stdenv.mkDerivation {
  name = "lrzip-0.23";

  src = fetchurl {
    url = http://ck.kolivas.org/apps/lrzip/lrzip-0.23.tar.bz2;
    sha256 = "52514a46228266230760fe8f7da9dd669b4c82160e9c238f029cd535d0988065";
  };

  NIX_CFLAGS_COMPILE = "-isystem ${zlib}/include";

  buildInputs = [ zlib lzo bzip2 nasm ];

  meta = {
    homepage = http://ck.kolivas.org/apps/lrzip/;
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = "GPLv2+";
  };
}
