{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-${version}";
  version = "2.15";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "09spyj4f05rjx21v8vmyqmmj0fz1wx810s63md1vf05hyzd0v8dk";
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
