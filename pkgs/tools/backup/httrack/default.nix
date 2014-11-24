{ stdenv, fetchurl, zlib, openssl }:

stdenv.mkDerivation rec {
  version = "3.48.20";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "129cpf324ihqxc8mvvkqjfanl17g60zfiqy1zx8ri56dkrg52mii";
  };

  buildInputs = [ zlib openssl ];

  meta = {
    homepage = "http://www.httrack.com";
    description = "Easy-to-use offline browser utility";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
