{ stdenv, fetchurl, zlib, openssl, libiconv }:

stdenv.mkDerivation rec {
  version = "3.49.2";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "09a0gm67nml86qby1k1gh7rdxamnrnzwr6l9r5iiq94favjs0xrl";
  };

  buildInputs = [ zlib openssl ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Easy-to-use offline browser / website mirroring utility";
    homepage    = http://www.httrack.com;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ the-kenny ];
    platforms   = with platforms; unix;
  };
}
