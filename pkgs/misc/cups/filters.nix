{
  lib,
  bc,
  coreutils,
  cups,
  dbus,
  dejavu_fonts,
  fetchFromGitHub,
  fontconfig,
  gawk,
  ghostscript,
  gnugrep,
  gnused,
  ijs,
  libcupsfilters,
  libppd,
  libexif,
  libjpeg,
  liblouis,
  libpng,
  makeWrapper,
  autoreconfHook,
  mupdf,
  perl,
  pkg-config,
  poppler,
  poppler-utils,
  qpdf,
  stdenv,
  which,
  withAvahi ? true,
  glib,
}:

(
  if !withAvahi then
    lib.warn "the 'withAvahi' parameter to 'cups-filters' is deprecated, as the cups-browsed component (which does not make sense without avahi) has been split out of the cups-filters package (which no longer needs avahi)"
  else
    lib.id
)

  (
    let
      binPath = lib.makeBinPath [
        bc
        coreutils
        gawk
        gnused
        gnugrep
        which
      ];

    in
    stdenv.mkDerivation rec {
      pname = "cups-filters";
      version = "2.0.1";

      src = fetchFromGitHub {
        owner = "OpenPrinting";
        repo = "cups-filters";
        rev = version;
        hash = "sha256-bLOl64bdeZ10JLcQ7GbU+VffJu3Lzo0ves7O7GQIOWY=";
      };

      strictDeps = true;

      nativeBuildInputs = [
        autoreconfHook
        cups
        glib
        makeWrapper
        pkg-config
      ];

      buildInputs = [
        cups
        ghostscript
        libcupsfilters
        libppd
        mupdf
      ];

      configureFlags = [
        "--with-mutool-path=${mupdf}/bin/mutool"
        "--with-gs-path=${ghostscript}/bin/gs"
        "--with-ippfind-path=${cups}/bin/ippfind"
        "--with-shell=${stdenv.shell}"
        "--localstatedir=/var"
        "--sysconfdir=/etc"
      ];

      makeFlags = [
        "CUPS_SERVERBIN=$(out)/lib/cups"
        "CUPS_DATADIR=$(out)/share/cups"
        "CUPS_SERVERROOT=$(out)/etc/cups"
      ];

      # https://github.com/OpenPrinting/cups-filters/issues/512
      env.NIX_CFLAGS_COMPILE = "-std=c++17";

      postConfigure = ''
        # Ensure that bannertopdf can find the PDF templates in
        # $out. (By default, it assumes that cups and cups-filters are
        # installed in the same prefix.)
        substituteInPlace config.h --replace ${cups.out}/share/cups/data $out/share/cups/data

        # Ensure that gstoraster can find gs in $PATH.
        substituteInPlace filter/gstoraster.c --replace execve execvpe

        # Patch shebangs of generated build scripts
        patchShebangs filter
      '';

      postInstall = ''
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
  )
