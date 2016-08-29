{ stdenv, fetchurl, pkgconfig, libxml2, gtk2 }:

stdenv.mkDerivation rec {
  version = "2.1.11";
  name = "ggobi-${version}";

  src = fetchurl {
    url = "http://www.ggobi.org/downloads/ggobi-${version}.tar.bz2";
    sha256 = "2c4ddc3ab71877ba184523e47b0637526e6f3701bd9afb6472e6dfc25646aed7";
  };

  buildInputs = [ pkgconfig libxml2 gtk2 ];

  configureFlags = "--with-all-plugins";

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Visualization program for exploring high-dimensional data";
    homepage = http://www.ggobi.org/;
    license = licenses.cpl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.michelk ];
  };
}
