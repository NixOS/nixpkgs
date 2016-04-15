{ stdenv, fetchurl, pkgconfig, cups, poppler, poppler_utils, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus, substituteAll, bash, avahi
, makeWrapper, coreutils, gnused, bc, gawk, gnugrep, which
}:

let
  binPath = stdenv.lib.makeBinPath [ coreutils gnused bc gawk gnugrep which ];

in stdenv.mkDerivation rec {
  name = "cups-filters-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "http://openprinting.org/download/cups-filters/${name}.tar.xz";
    sha256 = "0cjrh4wpdhkvmahfkg8f2a2qzilcq12i78q5arwr7dnmx1j8hapj";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [
    cups poppler poppler_utils fontconfig libjpeg libpng perl
    ijs qpdf dbus avahi
  ];

  configureFlags = [
    "--with-pdftops=pdftops"
    "--enable-imagefilters"
    "--with-rcdir=no"
    "--with-shell=${stdenv.shell}"
    "--with-test-font-path=/path-does-not-exist"
  ];

  makeFlags = [ "CUPS_SERVERBIN=$(out)/lib/cups" "CUPS_DATADIR=$(out)/share/cups" "CUPS_SERVERROOT=$(out)/etc/cups" ];

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
      for i in $out/lib/cups/filter/*; do
        wrapProgram "$i" --prefix PATH ':' ${binPath}
      done
    '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters;
    description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
