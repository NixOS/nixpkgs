{stdenv, fetchurl, zlib, lzo, bzip2, nasm, perl}:

stdenv.mkDerivation rec {
  version = "0.631";
  name = "lrzip-${version}";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${name}.tar.bz2";
    sha256 = "0mb449vmmwpkalq732jdyginvql57nxyd31sszb108yps1lf448d";
  };

  buildInputs = [ zlib lzo bzip2 nasm perl ];

  meta = {
    homepage = http://ck.kolivas.org/apps/lrzip/;
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = stdenv.lib.licenses.gpl2Plus;
    inherit version;
    platforms = stdenv.lib.platforms.unix;
  };
}
