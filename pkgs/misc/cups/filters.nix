{ stdenv, fetchurl, pkgconfig, cups, poppler, poppler_utils, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus, avahi
, makeWrapper, coreutils, gnused, bc, gawk, gnugrep, which, ghostscript
, mupdf
}:

let
  binPath = stdenv.lib.makeBinPath [ coreutils gnused bc gawk gnugrep which ];

in stdenv.mkDerivation rec {
  pname = "cups-filters";
  version = "1.25.12";

  src = fetchurl {
    url = "https://openprinting.org/download/cups-filters/${pname}-${version}.tar.xz";
    sha256 = "1kv25011iyzvd33n5zmmn1z2p6pzk26hmmw6qvjjnx8p3sp7raqn";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [
    cups poppler poppler_utils fontconfig libjpeg libpng perl
    ijs qpdf dbus avahi ghostscript mupdf
  ];

  configureFlags = [
    # TODO(Profpatsch): mupdf support
    "--with-pdftops=pdftops"
    "--with-pdftops-path=${poppler_utils}/bin/pdftops"
    "--with-gs-path=${ghostscript}/bin/gs"
    "--with-pdftocairo-path=${poppler_utils}/bin/pdftocairo"
    "--with-ippfind-path=${cups}/bin/ippfind"
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
  doCheck = false; # fails 4 out of 6 tests

  meta = {
    homepage = "http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters";
    description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
