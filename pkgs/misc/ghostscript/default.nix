{ stdenv, fetchurl, libjpeg, libpng, libtiff, zlib, pkgconfig, fontconfig, openssl
, x11Support, x11 ? null
, cupsSupport ? false, cups ? null
}:

assert x11Support -> x11 != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "ghostscript-8.64.0";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://gnu/ghostscript/gnu-${name}.tar.bz2";
    sha256 = "0b94vlf03saa8vm9drz1kishh527g0brw2cg3jcy9mgpp764x2v1";
  };

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

  configureFlags = ''
    ${if x11Support then "--with-x" else "--without-x"}
  '';

  NIX_CFLAGS_COMPILE = "-fpic";

  patches = [ ./purity.patch ./mkromfs-zlib.patch ./urw-font-files.patch ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/ghostscript/;
    description = "GNU Ghostscript, an PostScript interpreter";

    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';

    license = "GPLv2";
  };
}
