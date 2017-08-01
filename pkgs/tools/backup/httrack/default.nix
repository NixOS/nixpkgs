{ stdenv, fetchurl, zlib, openssl, libiconv }:

stdenv.mkDerivation rec {
  version = "3.49.1";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "0hm8wzxi839mfr4gj3lgd2bcg2p01ii2k268gik8k4dwr80anh46";
  };

  buildInputs = [ zlib openssl ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  meta = {
    homepage = "http://www.httrack.com";
    description = "Easy-to-use offline browser utility";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
