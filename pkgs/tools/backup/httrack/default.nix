{ stdenv, fetchurl, zlib, openssl, libiconv }:

stdenv.mkDerivation rec {
  version = "3.48.22";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "13y4m4rhvmgbbpc3lig9hzmzi86a5fkyi79sz1ckk4wfnkbim0xj";
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
