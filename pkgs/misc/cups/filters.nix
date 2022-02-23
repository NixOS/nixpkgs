{ lib
, avahi
, bc
, coreutils
, cups
, dbus
, dejavu_fonts
, fetchurl
, fontconfig
, gawk
, ghostscript
, gnugrep
, gnused
, ijs
, libjpeg
, liblouis
, libpng
, makeWrapper
, mupdf
, perl
, pkg-config
, poppler
, poppler_utils
, qpdf
, stdenv
, which
, withAvahi ? true
}:

let
  binPath = lib.makeBinPath [ bc coreutils gawk gnused gnugrep which ];

in
stdenv.mkDerivation rec {
  pname = "cups-filters";
  version = "1.28.12";

  src = fetchurl {
    url = "https://openprinting.org/download/cups-filters/${pname}-${version}.tar.xz";
    sha256 = "sha256-RuLqPYhK0iK7hjzmUR5ZzzkO+Og1KVvkSoDlALKjOjo=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [
    cups
    dbus
    fontconfig
    ghostscript
    ijs
    libjpeg
    liblouis # braille embosser support
    libpng
    mupdf
    perl
    poppler
    poppler_utils
    qpdf
  ] ++ lib.optionals withAvahi [ avahi ];

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
  ] ++ lib.optionals (!withAvahi) [ "--disable-avahi" ];

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
