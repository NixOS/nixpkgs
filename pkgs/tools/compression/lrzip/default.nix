{stdenv, fetchurl, zlib, lzo, bzip2, nasm, perl}:

stdenv.mkDerivation rec {
  version = "0.620";
  name = "lrzip-${version}";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${name}.tar.bz2";
    sha256 = "11ilyjrpdg0k29yidbxvz9aq54zvcxd4c308fjy578jgmlw8f2sd";
  };

  buildInputs = [ zlib lzo bzip2 nasm perl ];

  meta = {
    homepage = http://ck.kolivas.org/apps/lrzip/;
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = stdenv.lib.licenses.gpl2Plus;
    inherit version;
  };
}
