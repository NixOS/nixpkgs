{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-2.13";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "1lzgg6zpizcldb78n5gkykjnpr7sqm4r1xy9bm4ig0chbrink4ka";
  };

  buildInputs = [ pkgconfig libdaemon bison flex check ];

  hardeningEnable = [ "pie" ];

  meta = with stdenv.lib; {
    homepage = http://www.litech.org/radvd/;
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
