{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "pure-ftpd-1.0.46";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/${name}.tar.gz";
    sha256 = "0p0arcaz63fbb03fkavbc8z6m1f90p5vbnxb8mqlvpma6mrq0286";
  };

  buildInputs = [ openssl ];

  configureFlags = [ "--with-tls" ];

  meta = with stdenv.lib; {
    description = "A free, secure, production-quality and standard-conformant FTP server";
    homepage = https://www.pureftpd.org;
    license = licenses.isc; # with some parts covered by BSD3(?)
    maintainers = [ maintainers.lethalman ];
    platforms = platforms.unix;
  };
}
