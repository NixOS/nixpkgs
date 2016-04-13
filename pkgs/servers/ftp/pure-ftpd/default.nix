{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pure-ftpd-1.0.42";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/${name}.tar.gz";
    sha256 = "1yg7v1l3ng7c08nhh804k28y1f8ccmg0rq1a9l2sg45ib273mrvv";
  };

  meta = with stdenv.lib; {
    description = "A free, secure, production-quality and standard-conformant FTP server";
    homepage = https://www.pureftpd.org;
    license = licenses.isc; # with some parts covered by BSD3(?)
    maintainers = [ maintainers.lethalman ];
  };

}
