{ stdenv, fetchurl, pkgconfig, cups

, automake
, autoconf
, libtool
, which
, ijs
, qpdf

# deps from gentoo, which of those are required for building?
, ghostscript # ghostscript version can be overridden in the cups module easily
, poppler, fontconfig, freetype, lcms2, zlib, bc
, libpng, libjpeg, libtiff, avahi
}:

stdenv.mkDerivation {
  name = "cups-filter-1.0-for-cups-${cups.version}";

  src = fetchurl {
    url = http://www.openprinting.org/download/cups-filters/cups-filters-1.0-current.tar.gz;
    sha256 = "0qy7lqdrjjwi4g1fkr97hp46lin5qc5fb7ng36pl5yxhmf4ghyba";
  };

  enableParallelBuilding = true;

  buildInputs = [ 
    pkgconfig cups poppler

    ghostscript poppler fontconfig freetype lcms2 zlib bc
    libpng libjpeg libtiff avahi ijs qpdf


    automake libtool autoconf which
  ];

  configureFlags = [
    "--with-gs-path=${ghostscript}/bin/gs"
    "--with-pdftops-path=${ghostscript}/bin/pdftops"
  ];

  # without autogen.sh config.sub
  preConfigure = ''
    sh autogen.sh
    makeFlags="$makeFlags INITDDIR=$out/etc/rc.d/init.d"
    makeFlags="$makeFlags INITDIR=$out/etc/rc.d"
    makeFlags="$makeFlags CUPS_SERVERBIN=$out/lib/cups"
    makeFlags="$makeFlags CUPS_DATADIR=$out/share/cups"
    makeFlags="$makeFlags CUPS_SERVERROOT=$out/etc/cups"
    # makeFlags="$makeFlags CUPS_FONTPATH=$out/share/cups/fonts"

    sed -i \
      -e 's@#define BINDIR "/usr/bin"@#define BINDIR "/"@' \
      -e 's@#define GS "gs"@#define GS "${ghostscript}/bin/gs"@' \
      filter/gstoraster.c
  '';
  # NIX_CFLAGS_COMPILE=''-DBIN_DIR=\"/\" -DGS=\".${ghostscript}/bin/gs\"'';


  meta = {
    homepage = "http://www.linuxfoundation.org/collaborate/workgroups/openprinting/pdfasstandardprintjobformat";
    description = "Cups PDF filters";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
