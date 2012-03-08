{ stdenv, fetchurl, libjpeg, libpng, libtiff, zlib, pkgconfig, fontconfig, openssl, lcms, freetype
, x11Support, x11 ? null
, cupsSupport ? false, cups ? null
, gnuFork ? true
}:

assert x11Support -> x11 != null;
assert cupsSupport -> cups != null;

let
  meta = {
    homepage = http://www.gnu.org/software/ghostscript/;
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

  gnuForkData = rec {
    name = "ghostscript-9.04.1";
    src = fetchurl {
      url = "mirror://gnu/ghostscript/gnu-${name}.tar.bz2";
      sha256 = "0zqa6ggbkdqiszsywgrra4ij0sddlmrfa50bx2mh568qid4ga0a2";
    };

    inherit meta;
    patches = [ ./purity.patch ];
  };

  mainlineData = {
    name = "ghostscript-9.05";
    src = fetchurl {
      url = http://downloads.ghostscript.com/public/ghostscript-9.05.tar.bz2;
      sha256 = "1b6fi76x6pn9dmr9k9lh8kimn968dmh91k824fmm59d5ycm22h8g";
    };
    meta = meta // {
      homepage = http://www.ghostscript.com/;
      description = "GPL Ghostscript, a PostScript interpreter";
    };
    patches = [ ./purity-9.05.patch ];
  };

  variant = if gnuFork then gnuForkData else mainlineData;

in

stdenv.mkDerivation rec {
  inherit (variant) name src meta;

  fonts = [
    (fetchurl {
      url = mirror://gnu/ghostscript/gnu-gs-fonts-std-6.0.tar.gz;
      sha256 = "1lxr1y52r26qjif8kdqkfhsb5llakdcx3f5b9ppdyn59bb83ivsc";
    })
    (fetchurl {
      url = mirror://gnu/ghostscript/gnu-gs-fonts-other-6.0.tar.gz;
      sha256 = "1cxaah3r52qq152bbkiyj2f7dx1rf38vsihlhjmrvzlr8v6cqil1";
    })
    # ... add other fonts here
  ];

  buildInputs = [libjpeg libpng libtiff zlib pkgconfig fontconfig openssl lcms]
    ++ stdenv.lib.optionals x11Support [x11 freetype]
    ++ stdenv.lib.optional cupsSupport cups;

  CFLAGS = "-fPIC";
  NIX_LDFLAGS = "-lz -rpath=${freetype}/lib";

  patches = variant.patches ++ [ ./urw-font-files.patch ];

  preConfigure = ''
    # "ijs" is impure: it contains symlinks to /usr/share/automake etc.!
    rm -rf ijs/ltmain.sh

    # Don't install stuff in the Cups store path.
    makeFlagsArray=(CUPSSERVERBIN=$out/lib/cups CUPSSERVERROOT=$out/etc/cups CUPSDATA=$out/share/cups)
  '';

  configureFlags =
    (if x11Support then [ "--with-x" ] else [ "--without-x" ]) ++
    (if cupsSupport then [ "--enable-cups" "--with-install-cups" ] else [ "--disable-cups" ]);

  doCheck = true;

  installTargets="install soinstall";

  postInstall = ''
    for i in $fonts; do
      (cd $out/share/ghostscript && tar xvfz $i)
    done
  '';
}
