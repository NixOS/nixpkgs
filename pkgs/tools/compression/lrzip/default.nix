{stdenv, fetchurl, zlib, lzo, bzip2, nasm, perl}:

stdenv.mkDerivation rec {
  version = "0.621";
  name = "lrzip-${version}";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${name}.tar.bz2";
    sha256 = "0szb1habydj9fwwrhgpjfws6v7hdphnqc5527i0vvc5rx2z6zhii";
  };

  buildInputs = [ zlib lzo bzip2 nasm perl ];

  meta = {
    homepage = http://ck.kolivas.org/apps/lrzip/;
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = stdenv.lib.licenses.gpl2Plus;
    inherit version;
  };
}
