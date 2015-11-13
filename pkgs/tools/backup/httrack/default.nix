{ stdenv, fetchurl, zlib, openssl, libiconv }:

stdenv.mkDerivation rec {
  version = "3.48.21";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "10p4gf8y9h7mxkqlbs3hqgvmvbgvcbax8jp1whbw4yidwahn06w7";
  };

  buildInputs = [ zlib openssl ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  meta = {
    homepage = "http://www.httrack.com";
    description = "Easy-to-use offline browser utility";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
