{ lib, stdenv, fetchurl, openssl, pam, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pure-ftpd";
  version = "1.0.50";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-${version}.tar.gz";
    sha256 = "08zas1kg5pnckl28gs7q29952pjfyj8rj59bq96hscqbni7gkqmb";
  };

  buildInputs = [ openssl pam ];

  configureFlags = [ "--with-tls" ];

  meta = with lib; {
    description = "A free, secure, production-quality and standard-conformant FTP server";
    homepage = "https://www.pureftpd.org";
    license = licenses.isc; # with some parts covered by BSD3(?)
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
