{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-${version}";
  version = "2.17";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "1md6n63sg1n9x8yv0p7fwm1xxaiadj1q3mpadiqsvn14y1ddc2av";
  };

  nativeBuildInputs = [ pkgconfig bison flex check ];
  buildInputs = [ libdaemon ];

  meta = with stdenv.lib; {
    homepage = http://www.litech.org/radvd/;
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
