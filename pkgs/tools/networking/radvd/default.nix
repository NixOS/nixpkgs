{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-2.10";
  
  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "0wwpzdkk6lpsai11iwsrwiblmf9x19rds0wdqcnf82hj0j1yxkkn";
  };

  buildInputs = [ pkgconfig libdaemon bison flex check ];

  meta = with stdenv.lib; {
    homepage = http://www.litech.org/radvd/;
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ wkennington ];
  };
}
