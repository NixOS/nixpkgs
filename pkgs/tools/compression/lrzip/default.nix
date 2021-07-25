{ lib, stdenv, fetchurl, zlib, lzo, bzip2, lz4, nasm, perl }:

stdenv.mkDerivation rec {
  pname = "lrzip";
  version = "0.641";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${pname}-${version}.tar.xz";
    sha256 = "0ziyanspd96dc3lp2qdcylc7aq8dhb511jhqrhxvlp502fjqjqrc";
  };

  buildInputs = [ zlib lzo bzip2 lz4 nasm perl ];

  configureFlags = [
    "--disable-asm"
  ];

  meta = with lib; {
    homepage = "http://ck.kolivas.org/apps/lrzip/";
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
