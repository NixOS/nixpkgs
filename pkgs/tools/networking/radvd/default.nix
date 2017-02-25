{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-${version}";
  version = "2.16";

  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "1s3aqgn3db0wb4920b0mrvwb5isgijlb6izb1wliqhhashwffz1i";
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
