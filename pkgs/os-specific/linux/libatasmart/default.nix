{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libatasmart-0.19";

  src = fetchurl {
    url = "http://0pointer.de/public/${name}.tar.xz";
    sha256 = "138gvgdwk6h4ljrjsr09pxk1nrki4b155hqdzyr8mlk3bwsfmw31";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev ];

  meta = with stdenv.lib; {
    homepage = http://0pointer.de/blog/projects/being-smart.html;
    description = "Library for querying ATA SMART status";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
