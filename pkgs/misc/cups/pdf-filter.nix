{ stdenv, fetchurl, pkgconfig, cups, poppler }:

let version = "1.4.5"; in

stdenv.mkDerivation {
  name = "cups-pdf-filter-${version}";

  src = fetchurl {
    url = "http://ftp.easysw.com/pub/cups/${version}/cups-${version}-source.tar.bz2";
    sha256 = "1zhf3hvx11i0qnbwyybmdhx4fxkxfd4ch69k59fj5bz8wvcdcl04";
  };

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
    mkdir -pv $out/lib/cups/filter
    cp -v pdftops $out/lib/cups/filter
    '';


  meta = {
    homepage = http://www.cups.org/;
    description = "Image and pdf filters for CUPS";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
