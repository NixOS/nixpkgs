{ stdenv, fetchurl, pkgconfig, zlib, expat, openssl
, libjpeg, libpng, libtiff, freetype, fontconfig, lcms2, libpaper, jbig2dec
, libiconv
, x11Support ? false, x11 ? null
, cupsSupport ? false, cups ? null
}:

assert x11Support -> x11 != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "ghostscript-9.15";

  src = fetchurl {
    url = "http://downloads.ghostscript.com/public/${name}.tar.bz2";
    sha256 = "0p1isp6ssfay141klirn7n9s8b546vcz6paksfmksbwy0ljsypg6";
  };

  fonts = [
    (fetchurl {
      url = "mirror://sourceforge/gs-fonts/ghostscript-fonts-std-8.11.tar.gz";
      sha256 = "00f4l10xd826kak51wsmaz69szzm2wp8a41jasr4jblz25bg7dhf";
    })
    (fetchurl {
      url = "mirror://gnu/ghostscript/gnu-gs-fonts-other-6.0.tar.gz";
      sha256 = "1cxaah3r52qq152bbkiyj2f7dx1rf38vsihlhjmrvzlr8v6cqil1";
    })
    # ... add other fonts here
  ];

  enableParallelBuilding = true;

  buildInputs =
    [ pkgconfig zlib expat openssl
      libjpeg libpng libtiff freetype fontconfig lcms2 libpaper jbig2dec
      libiconv
    ]
    ++ stdenv.lib.optional x11Support x11
    ++ stdenv.lib.optional cupsSupport cups
    # [] # maybe sometimes jpeg2000 support
    ;

  patches = [ ./urw-font-files.patch ];

  makeFlags = [ "cups_serverroot=$(out)" "cups_serverbin=$(out)/lib/cups" ];

  configureFlags =
    [ "--with-system-libtiff" "--disable-sse2"
      "--enable-dynamic"
      (if x11Support then "--with-x" else "--without-x")
      (if cupsSupport then "--enable-cups" else "--disable-cups")
    ];

  doCheck = true;

  installTargets="install soinstall";

  #CFLAGS = "-fPIC";
  #NIX_LDFLAGS =
  #  "-lz -rpath${ if stdenv.isDarwin then " " else "="}${freetype}/lib";

  preConfigure = ''
    rm -rf jpeg libpng zlib jasper expat tiff lcms{,2} jbig2dec openjpeg freetype cups/libs

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
  '';

  postInstall = ''
    # ToDo: web says the fonts should be already included
    for i in $fonts; do
      (cd $out/share/ghostscript && tar xvfz $i)
    done

    rm -rf $out/lib/cups/filter/{gstopxl,gstoraster}
  '';

  meta = {
    homepage = "http://www.ghostscript.com/";
    description = "PostScript interpreter (mainline version)";

    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
