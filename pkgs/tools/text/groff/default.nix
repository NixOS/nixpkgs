{ stdenv, fetchurl, perl
, ghostscript #for postscript and html output
, psutils, netpbm #for html output
, buildPackages
, autoreconfHook
, pkgconfig
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "groff";
  version = "1.22.4";

  src = fetchurl {
    url = "mirror://gnu/groff/${pname}-${version}.tar.gz";
    sha256 = "14q2mldnr1vx0l9lqp9v2f6iww24gj28iyh4j2211hyynx67p3p7";
  };

  outputs = [ "out" "man" "doc" "info" "perl" ];

  enableParallelBuilding = false;

  patches = [
    ./0001-Fix-cross-compilation-by-looking-for-ar.patch
  ];

  postPatch = stdenv.lib.optionalString (psutils != null) ''
    substituteInPlace src/preproc/html/pre-html.cpp \
      --replace "psselect" "${psutils}/bin/psselect"
  '' + stdenv.lib.optionalString (netpbm != null) ''
    substituteInPlace src/preproc/html/pre-html.cpp \
      --replace "pnmcut" "${stdenv.lib.getBin netpbm}/bin/pnmcut" \
      --replace "pnmcrop" "${stdenv.lib.getBin netpbm}/bin/pnmcrop" \
      --replace "pnmtopng" "${stdenv.lib.getBin netpbm}/bin/pnmtopng"
    substituteInPlace tmac/www.tmac \
      --replace "pnmcrop" "${stdenv.lib.getBin netpbm}/bin/pnmcrop" \
      --replace "pngtopnm" "${stdenv.lib.getBin netpbm}/bin/pngtopnm" \
      --replace "@PNMTOPS_NOSETPAGE@" "${stdenv.lib.getBin netpbm}/bin/pnmtops -nosetpage"
  '';

  buildInputs = [ ghostscript psutils netpbm perl ];
  nativeBuildInputs = [ autoreconfHook pkgconfig texinfo ];

  # Builds running without a chroot environment may detect the presence
  # of /usr/X11 in the host system, leading to an impure build of the
  # package. To avoid this issue, X11 support is explicitly disabled.
  # Note: If we ever want to *enable* X11 support, then we'll probably
  # have to pass "--with-appresdir", too.
  configureFlags = [
    "--without-x"
  ] ++ stdenv.lib.optionals (ghostscript != null) [
    "--with-gs=${ghostscript}/bin/gs"
  ] ++ stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_path_PERL=${buildPackages.perl}/bin/perl"
  ];

  makeFlags = stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # Trick to get the build system find the proper 'native' groff
    # http://www.mail-archive.com/bug-groff@gnu.org/msg01335.html
    "GROFF_BIN_PATH=${buildPackages.groff}/bin"
    "GROFFBIN=${buildPackages.groff}/bin/groff"
  ];

  doCheck = true;

  postInstall = ''
    for f in 'man.local' 'mdoc.local'; do
        cat '${./site.tmac}' >>"$out/share/groff/site-tmac/$f"
    done

    moveToOutput bin/gropdf $perl
    moveToOutput bin/pdfmom $perl
    moveToOutput bin/roff2text $perl
    moveToOutput bin/roff2pdf $perl
    moveToOutput bin/roff2ps $perl
    moveToOutput bin/roff2dvi $perl
    moveToOutput bin/roff2ps $perl
    moveToOutput bin/roff2html $perl
    moveToOutput bin/glilypond $perl
    moveToOutput bin/mmroff $perl
    moveToOutput bin/roff2x $perl
    moveToOutput bin/afmtodit $perl
    moveToOutput bin/gperl $perl
    moveToOutput bin/chem $perl

    moveToOutput bin/gpinyin $perl
    moveToOutput lib/groff/gpinyin $perl
    substituteInPlace $perl/bin/gpinyin \
      --replace $out/lib/groff/gpinyin $perl/lib/groff/gpinyin

    moveToOutput bin/groffer $perl
    moveToOutput lib/groff/groffer $perl
    substituteInPlace $perl/bin/groffer \
      --replace $out/lib/groff/groffer $perl/lib/groff/groffer

    moveToOutput bin/grog $perl
    moveToOutput lib/groff/grog $perl
    substituteInPlace $perl/bin/grog \
      --replace $out/lib/groff/grog $perl/lib/groff/grog

  '' + stdenv.lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    find $perl/ -type f -print0 | xargs --null sed -i 's|${buildPackages.perl}|${perl}|'
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.gnu.org/software/groff/";
    description = "GNU Troff, a typesetting package that reads plain text and produces formatted output";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];

    longDescription = ''
      groff is the GNU implementation of troff, a document formatting
      system.  Included in this release are implementations of troff,
      pic, eqn, tbl, grn, refer, -man, -mdoc, -mom, and -ms macros,
      and drivers for PostScript, TeX dvi format, HP LaserJet 4
      printers, Canon CAPSL printers, HTML and XHTML format (beta
      status), and typewriter-like devices.  Also included is a
      modified version of the Berkeley -me macros, the enhanced
      version gxditview of the X11 xditview previewer, and an
      implementation of the -mm macros.
    '';

    outputsToInstall = [ "out" "perl" ];
  };
}
