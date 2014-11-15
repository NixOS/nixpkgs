{ stdenv, fetchurl, autoreconfHook, pkgconfig, cups, libjpeg, ghostscript
, dejavu_fonts, libpng, libtiff, glib, lcms, freetype, fontconfig, ijs, poppler
, zlib, qpdf, dbus }:

stdenv.mkDerivation rec {
  name = "cups-filters-1.0.61";

  src = fetchurl {
    url = "https://www.openprinting.org/download/cups-filters/${name}.tar.gz";
    sha256 = "0mri36qih4vniycbga8aczmdf0qkiwyyi5hv8x9mg2f6a9wj8ch9";
  };

  configureFlags = [ "--with-test-font-path=${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf"
                     "--with-cups-domainsocket=/var/run/cups/cups.sock"
                     "--with-rcdir=no"
                   ];

  buildInputs = [ ghostscript cups libjpeg libpng libtiff glib lcms freetype fontconfig
                  poppler zlib ijs qpdf dbus
                ];

  patches = [ ./fix-cups-path.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters;
    description = "Backends, filters, and other software that was once part of the core CUPS distribution";
    license = "cups-filters";
    maintainers = maintainers.abbradar;
    platforms = stdenv.lib.platforms.linux;
  };
}
