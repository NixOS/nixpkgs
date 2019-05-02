{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "pure-ftpd-1.0.49";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/${name}.tar.gz";
    sha256 = "19cjr262n6h560fi9nm7l1srwf93k34bp8dp1c6gh90bqxcg8yvn";
  };

  buildInputs = [ openssl ];

  configureFlags = [ "--with-tls" ];

  meta = with stdenv.lib; {
    description = "A free, secure, production-quality and standard-conformant FTP server";
    homepage = https://www.pureftpd.org;
    license = licenses.isc; # with some parts covered by BSD3(?)
    maintainers = [ maintainers.lethalman ];
    platforms = platforms.linux;
  };
}
