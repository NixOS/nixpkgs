{stdenv, fetchurl, zlib, lzo, bzip2, nasm, perl}:

stdenv.mkDerivation rec {
  name = "lrzip-0.606";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${name}.tar.bz2";
    sha256 = "03qxqs7y868w2kfpa84xmhdnh3b4j9x29g4hkzyrg8f4cxgkcv8k";
  };

  buildInputs = [ zlib lzo bzip2 nasm perl ];

  meta = {
    homepage = http://ck.kolivas.org/apps/lrzip/;
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = "GPLv2+";
  };
}
