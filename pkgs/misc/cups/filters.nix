{ lib
, avahi
, bc
, coreutils
, cups
, dbus
, dejavu_fonts
, fetchurl
, fetchpatch
, fontconfig
, gawk
, ghostscript
, gnugrep
, gnused
, ijs
, libexif
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
  version = "1.28.17";

  src = fetchurl {
    url = "https://github.com/OpenPrinting/cups-filters/releases/download/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-Jwo3UqlgNoqpnUMftdNPQDmyrJQ8V22EBhLR2Bhcm7k=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-24805.patch";
      url = "https://github.com/OpenPrinting/cups-filters/commit/93e60d3df358c0ae6f3dba79e1c9684657683d89.patch";
      hash = "sha256-KgWTYFr2uShL040azzE+KaNyBPy7Gs/hCnEgQmmPCys=";
    })
    (fetchpatch {
      name = "CVE-2024-47076.patch";
      url = "https://github.com/OpenPrinting/libcupsfilters/commit/95576ec3d20c109332d14672a807353cdc551018.patch";
      hash = "sha256-MXWllrdWt8n7zqvumQNg34dBgWMwMTwf9lrD+ZZP8Wk=";
    })
  ];

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [
    cups
    dbus
    fontconfig
    ghostscript
    ijs
    libexif
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

  # https://github.com/OpenPrinting/cups-filters/issues/512
  env.NIX_CFLAGS_COMPILE = "-std=c++17";

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
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
