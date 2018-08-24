{ stdenv, fetchurl, pkgconfig, cups, poppler, poppler_utils, fontconfig
, libjpeg, libpng, perl, ijs, qpdf, dbus, avahi
, makeWrapper, coreutils, gnused, bc, gawk, gnugrep, which, ghostscript
, mupdf
, fetchpatch
}:

let
  binPath = stdenv.lib.makeBinPath [ coreutils gnused bc gawk gnugrep which ];

in stdenv.mkDerivation rec {
  name = "cups-filters-${version}";
  version = "1.20.4";

  src = fetchurl {
    url = "https://openprinting.org/download/cups-filters/${name}.tar.xz";
    sha256 = "0sjkmclcb1r77015wllsyz26272br3s17v6b1q2xwb2nm2gnwx9k";
  };

  patches = [
    # This patch fixes cups-filters when compiled with poppler-0.67.0.
    # Issue: https://github.com/OpenPrinting/cups-filters/pull/50
    # PR: https://github.com/OpenPrinting/cups-filters/pull/51
    (fetchpatch {
      url = "https://github.com/OpenPrinting/cups-filters/commit/219de01c61f3b1ec146abf142d0dfc8c560cc58e.patch";
      sha256 = "0f0lql3rbm2g8mxrpigfyi8fb4i2g4av20g417jzdilp60jq0ny8";
    })
  ];

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
  doCheck = false; # fails 4 out of 6 tests

  meta = {
    homepage = http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters;
    description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
