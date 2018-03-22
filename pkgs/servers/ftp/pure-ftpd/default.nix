{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "pure-ftpd-1.0.47";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/${name}.tar.gz";
    sha256 = "1b97ixva8m10vln8xrfwwwzi344bkgxqji26d0nrm1yzylbc6h27";
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
