{ stdenv, fetchurl, pkgconfig, cups, poppler, poppler_utils, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus, substituteAll, bash, avahi }:

stdenv.mkDerivation rec {
  name = "cups-filters-${version}";
  version = "1.0.61";

  src = fetchurl {
    url = "http://openprinting.org/download/cups-filters/${name}.tar.xz";
    sha256 = "1bq48nnrarlbf6qc93bz1n5wlh6j420gppbck3r45sinwhz5wa7m";
  };

  patches = [
    (substituteAll {
      src = ./longer-shell-path.patch;
      bash = "${bash}/bin/bash";
    })

    # Fix build with poppler-0.31.0
    (fetchurl {
      url = "https://bugs.linuxfoundation.org/attachment.cgi?id=476";
      name = "cups-filters-poppler-0.31.0.patch";
      sha256 = "016pzksz4nl1sv3p5ahlnbmb7c899yrvlzq8jxic0gvdrzwd5bl4";
    })
  ];

  buildInputs = [
    pkgconfig cups poppler poppler_utils fontconfig libjpeg libpng perl
    ijs qpdf dbus avahi
  ];

  configureFlags = "--with-pdftops=pdftops --enable-imagefilters --with-rcdir=no";

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
