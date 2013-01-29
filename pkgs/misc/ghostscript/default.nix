{ stdenv, fetchurl, libjpeg, libpng, libtiff, zlib, pkgconfig, fontconfig, openssl
, lcms2, freetype, libpaper, jbig2dec, expat
, x11Support, x11 ? null
, cupsSupport ? false, cups ? null
, gnuFork ? true
}:

assert x11Support -> x11 != null;
assert cupsSupport -> cups != null;

let
  meta = {
    homepage = "http://www.gnu.org/software/ghostscript/";
    description = "GNU Ghostscript, a PostScript interpreter";

    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';

    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.viric ];
  };

  gnuForkSrc = rec {
    name = "ghostscript-9.04.1";
    src = fetchurl {
      url = "mirror://gnu/ghostscript/gnu-${name}.tar.bz2";
      sha256 = "0zqa6ggbkdqiszsywgrra4ij0sddlmrfa50bx2mh568qid4ga0a2";
    };

    inherit meta;
    patches = [ ./purity.patch ];
  };

  mainlineSrc = rec {
    name = "ghostscript-9.06";
    src = fetchurl {
      url = "http://downloads.ghostscript.com/public/${name}.tar.bz2";
      sha256 = "014f10rxn4ihvcr1frby4szd1jvkrwvmdhnbivpp55c9fssx3b05";
    };
    meta = meta // {
      homepage = "http://www.ghostscript.com/";
      description = "GPL Ghostscript, a PostScript interpreter";
    };

    preConfigure = ''
      rm -R libpng jpeg lcms{,2} tiff freetype jbig2dec expat jasper openjpeg

      substituteInPlace base/unix-aux.mak --replace "INCLUDE=/usr/include" "INCLUDE=/no-such-path"
      sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@" -i base/unix-aux.mak
    '';
    patches = [];
  };

  variant = if gnuFork then gnuForkSrc else mainlineSrc;

in

stdenv.mkDerivation rec {
  inherit (variant) name src meta;

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

  buildInputs = [
    libjpeg libpng libtiff zlib pkgconfig fontconfig openssl lcms2
    libpaper jbig2dec expat
  ] ++ stdenv.lib.optionals x11Support [x11 freetype]
    ++ stdenv.lib.optional cupsSupport cups
    # [] # maybe sometimes jpeg2000 support
    ;

  CFLAGS = "-fPIC";
  NIX_LDFLAGS =
    "-lz -rpath${ if stdenv.isDarwin then " " else "="}${freetype}/lib";

  patches = variant.patches ++ [ ./urw-font-files.patch ];

  preConfigure = ''
    # "ijs" is impure: it contains symlinks to /usr/share/automake etc.!
    rm -rf ijs/ltmain.sh

    # Don't install stuff in the Cups store path.
    makeFlagsArray=(CUPSSERVERBIN=$out/lib/cups CUPSSERVERROOT=$out/etc/cups CUPSDATA=$out/share/cups)
  '' + stdenv.lib.optionalString (variant ? preConfigure) variant.preConfigure;

  configureFlags = [ "--with-system-libtiff" ] ++
    (if x11Support then [ "--with-x" ] else [ "--without-x" ]) ++
    (if cupsSupport then [ "--enable-cups" "--with-install-cups" ] else [ "--disable-cups" ]);

  doCheck = true;

  installTargets="install soinstall";

  # ToDo: web says the fonts should be already included
  postInstall = ''
    for i in $fonts; do
      (cd $out/share/ghostscript && tar xvfz $i)
    done
  '';
}
