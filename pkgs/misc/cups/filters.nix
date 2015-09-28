{ stdenv, fetchurl, fetchpatch, pkgconfig, cups, poppler, poppler_utils, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus, substituteAll, bash, avahi }:

stdenv.mkDerivation rec {
  name = "cups-filters-${version}";
  version = "1.0.71";

  src = fetchurl {
    url = "http://openprinting.org/download/cups-filters/${name}.tar.xz";
    sha256 = "07wwlqcykfjfqcwj1bxk60ggahyaw7wcx32n5s104d1qkhham01i";
  };

  patches = [(fetchpatch { # drop on update
    name = "poppler-0.34.patch";
    url = "https://bugs.linuxfoundation.org/attachment.cgi?id=493";
    sha256 = "18za83q0b0n4hpvvw76jsv0hm89zmijvps2z5kg1srickqlxj891";
  })];

  buildInputs = [
    pkgconfig cups poppler poppler_utils fontconfig libjpeg libpng perl
    ijs qpdf dbus avahi
  ];

  configureFlags = [
    "--with-pdftops=pdftops"
    "--enable-imagefilters"
    "--with-rcdir=no"
    "--with-shell=${stdenv.shell}"
  ];

  makeFlags = "CUPS_SERVERBIN=$(out)/lib/cups CUPS_DATADIR=$(out)/share/cups CUPS_SERVERROOT=$(out)/etc/cups";

  postConfigure =
    ''
      # Ensure that bannertopdf can find the PDF templates in
      # $out. (By default, it assumes that cups and cups-filters are
      # installed in the same prefix.)
      substituteInPlace config.h --replace ${cups}/share/cups/data $out/share/cups/data

      # Ensure that gstoraster can find gs in $PATH.
      substituteInPlace filter/gstoraster.c --replace execve execvpe
    '';

  postInstall =
    ''
      for i in $out/lib/cups/filter/{pstopdf,texttops,imagetops}; do
        substituteInPlace $i --replace 'which ' 'type -p '
      done
    '';

  meta = {
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters;
    description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
