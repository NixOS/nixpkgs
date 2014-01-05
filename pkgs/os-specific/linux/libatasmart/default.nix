{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libatasmart-0.19";

  src = fetchurl {
    url = "http://0pointer.de/public/${name}.tar.xz";
    sha256 = "138gvgdwk6h4ljrjsr09pxk1nrki4b155hqdzyr8mlk3bwsfmw31";
  };

  buildInputs = [ pkgconfig udev ];

  meta = {
    homepage = http://0pointer.de/public/;
    description = "Library for querying ATA SMART status";
    platforms = stdenv.lib.platforms.linux;
  };
}
