{lib, stdenv, fetchurl, zlib, lzo, bzip2, lz4, nasm, perl}:

stdenv.mkDerivation rec {
  version = "0.640";
  pname = "lrzip";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${pname}-${version}.tar.xz";
    sha256 = "175466drfpz8rsfr0pzfn5rqrj3wmcmcs3i2sfmw366w2kbjm4j9";
  };

  buildInputs = [ zlib lzo bzip2 lz4 nasm perl ];

  configureFlags = [
    "--disable-asm"
  ];

  meta = {
    homepage = "http://ck.kolivas.org/apps/lrzip/";
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = lib.licenses.gpl2Plus;
    inherit version;
    platforms = lib.platforms.unix;
  };
}
