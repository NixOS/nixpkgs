{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "pure-ftpd-1.0.48";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/${name}.tar.gz";
    sha256 = "1xr1wlf08qaw93irsbdk4kvhqnkvmi6p0jb8kiiz0vr0h92pszxl";
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
