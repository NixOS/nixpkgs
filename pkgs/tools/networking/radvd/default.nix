{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-2.11";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "1k2sbfs4w2lkgz2mh4zh66fgahjrn2hvxcpfc091bykrzj464qq4";
  };

  buildInputs = [ pkgconfig libdaemon bison flex check ];

  hardening_pie = true;

  meta = with stdenv.lib; {
    homepage = http://www.litech.org/radvd/;
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ wkennington ];
  };
}
