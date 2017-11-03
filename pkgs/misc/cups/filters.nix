{ stdenv, fetchurl, pkgconfig, cups, poppler, poppler_utils, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus, substituteAll, bash, avahi
, makeWrapper, coreutils, gnused, bc, gawk, gnugrep, which, ghostscript
, mupdf
}:

let
  binPath = stdenv.lib.makeBinPath [ coreutils gnused bc gawk gnugrep which ];

in stdenv.mkDerivation rec {
  name = "cups-filters-${version}";
  version = "1.16.0";

  src = fetchurl {
    url = "http://openprinting.org/download/cups-filters/${name}.tar.xz";
    sha256 = "1kcndzpbbcaxafnz1wa6acy3p3r5likfqmf057i5q0q6i176lz5k";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [
    cups poppler poppler_utils fontconfig libjpeg libpng perl
    ijs qpdf dbus avahi ghostscript mupdf
  ];

  configureFlags = [
    "--with-pdftops=pdftops"
    "--with-pdftops-path=${poppler_utils}/bin/pdftops"
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
      substituteInPlace config.h --replace ${cups.out}/share/cups/data $out/share/cups/data

      # Ensure that gstoraster can find gs in $PATH.
      substituteInPlace filter/gstoraster.c --replace execve execvpe

      # Patch shebangs of generated build scripts
      patchShebangs filter
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
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
