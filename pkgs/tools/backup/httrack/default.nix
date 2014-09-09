{ stdenv, fetchurl, zlib, openssl }:

stdenv.mkDerivation rec {
  version = "3.48.19";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "1zlayvl6x0ck1g5rvmj7cc88w0an5f4y93r3g5l10hhhl87cvw0n";
  };

  buildInputs = [ zlib openssl ];

  meta = {
    homepage = "http://www.httrack.com";
    description = "Easy-to-use offline browser utility";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
