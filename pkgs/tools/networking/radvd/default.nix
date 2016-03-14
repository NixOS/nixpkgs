{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-2.12";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "0yvlzzdxz2h5fm7grbf1xfs8008bzcdjpficm2cf52g771rffw5h";
  };

  buildInputs = [ pkgconfig libdaemon bison flex check ];

  meta = with stdenv.lib; {
    homepage = http://www.litech.org/radvd/;
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
