{ stdenv, fetchurl, libjpeg, libpng, libtiff, zlib, pkgconfig, fontconfig, openssl
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
    name = "ghostscript-8.71.1";
    src = fetchurl {
      url = "mirror://gnu/ghostscript/gnu-${name}.tar.bz2";
      sha256 = "0vab9905h6sl5s5miai4vhhwdacjlkxqmykfr42x32sr25wjqgvl";
    };

    inherit meta;
  };

  mainlineData = {
    name = "ghostscript-9.02";
    src = fetchurl {
      url = http://downloads.ghostscript.com/public/ghostscript-9.02.tar.bz2;
      sha256 = "0np0kr02bsqzag9sdbcg2kkjda0rjsvi484ic28qyvx32fnjrsh3";
    };
    meta = meta // {
      homepage = http://www.ghostscript.com/;
      description = "GPL Ghostscript, a PostScript interpreter";
    };
  };

  variant = if gnuFork then gnuForkData else mainlineData;

in

stdenv.mkDerivation rec {
  inherit (variant) name src meta;

  builder = ./builder.sh;

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

  buildInputs = [libjpeg libpng libtiff zlib pkgconfig fontconfig openssl]
    ++ stdenv.lib.optional x11Support x11
    ++ stdenv.lib.optional cupsSupport cups;

  configureFlags =
    if x11Support then [ "--with-x" ] else [ "--without-x" ];

  CFLAGS = "-fPIC";

  patches = [ ./purity.patch ./urw-font-files.patch ]
    ++ stdenv.lib.optional gnuFork ./pstoraster.patch;

  doCheck = true;
}
