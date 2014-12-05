{ stdenv, fetchurl, pkgconfig, cups, poppler, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus }:

stdenv.mkDerivation rec {
  name = "cups-filters-${version}";
  version = "1.0.61";

  src = fetchurl {
    url = "http://openprinting.org/download/cups-filters/${name}.tar.xz";
    sha256 = "1bq48nnrarlbf6qc93bz1n5wlh6j420gppbck3r45sinwhz5wa7m";
  };

  buildInputs = [ 
    pkgconfig cups poppler fontconfig libjpeg libpng perl
    ijs qpdf dbus
  ];

  preBuild = ''
    substituteInPlace Makefile --replace "/etc/rc.d" "$out/etc/rc.d"
  '';
  configureFlags = "--with-pdftops=pdftops --enable-imagefilters";
  makeFlags = "CUPS_SERVERBIN=$(out)/lib/cups CUPS_DATADIR=$(out)/share/cups CUPS_SERVERROOT=$(out)/etc/cups";

  meta = {
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters;
    description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
