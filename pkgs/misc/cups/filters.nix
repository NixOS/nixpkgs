{ lib, stdenv, fetchurl, pkg-config, cups, poppler, poppler_utils, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus, avahi
, makeWrapper, coreutils, gnused, bc, gawk, gnugrep, which, ghostscript
, mupdf, dejavu_fonts, liblouis
}:

let
  binPath = lib.makeBinPath [ coreutils gnused bc gawk gnugrep which ];

in stdenv.mkDerivation rec {
  pname = "cups-filters";
  version = "1.28.11";

  src = fetchurl {
    url = "https://openprinting.org/download/cups-filters/${pname}-${version}.tar.xz";
    sha256 = "sha256-KYbLSNE0Db5XnELAjCqINYem2+WUNuQi9BhMzQqWZm0=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [
    cups poppler poppler_utils fontconfig libjpeg libpng perl
    ijs qpdf dbus avahi ghostscript mupdf
    liblouis # braille embosser support
  ];

  configureFlags = [
    "--with-mutool-path=${mupdf}/bin/mutool"
    "--with-pdftops=pdftops"
    "--with-pdftops-path=${poppler_utils}/bin/pdftops"
    "--with-gs-path=${ghostscript}/bin/gs"
    "--with-pdftocairo-path=${poppler_utils}/bin/pdftocairo"
    "--with-ippfind-path=${cups}/bin/ippfind"
    "--enable-imagefilters"
    "--with-rcdir=no"
    "--with-shell=${stdenv.shell}"
    "--with-test-font-path=${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
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
  doCheck = true;

  meta = {
    homepage = "http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters";
    description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
