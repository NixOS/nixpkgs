{ stdenv, fetchurl, pkgconfig, cups, poppler }:

stdenv.mkDerivation {
  name = "cups-pdf-filter-${cups.version}";

  inherit (cups) src;

  buildInputs = [ pkgconfig cups poppler ];

  preConfigure = ''
    sed -e 's@\.\./cups/$(LIBCUPS)@@' -e 's@$(LIBCUPSIMAGE)@@' -i filter/Makefile
    ''; 

  NIX_LDFLAGS="-L${cups}/lib";

  configureFlags = ''
    --localstatedir=/var --enable-dbus
    --enable-image --with-pdftops=pdftops'';

  buildPhase = ''
    cd filter
    make pdftops
    '';

  installPhase = ''
    mkdir -pv $out/lib/cups/filter $out/share/cups/mime
    cp -v pdftops $out/lib/cups/filter
    echo >$out/share/cups/mime/pdftops.convs 'application/pdf application/vnd.cups-postscript 66 pdftops'
    '';


  meta = {
    homepage = http://www.cups.org/;
    description = "Image and pdf filters for CUPS";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
