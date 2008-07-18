{ stdenv, fetchurl, libjpeg, libpng, zlib
, x11Support, x11 ? null
}:

assert x11Support -> x11 != null;

stdenv.mkDerivation rec {
  name = "ghostscript-8.62.0";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://gnu/ghostscript/gnu-${name}.tar.bz2"; 
    sha256 = "0zgvmhrxzdxc3lp7im7qcdmv0jlmbnp1fk0zs0hr3fqa943ywyg2";
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

  buildInputs = [libjpeg libpng zlib]
    ++ stdenv.lib.optional x11Support x11;

  configureFlags = "
    --disable-static
    ${if x11Support then "--with-x" else "--without-x"}
  ";

  NIX_CFLAGS_COMPILE = "-fpic";

  patches = [

    # This patch is required to make Ghostscript at least build in a
    # pure environment (like NixOS).  Ghostscript's build process
    # performs various tests for the existence of files in
    # /usr/include.
    ./purity.patch

    ./mkromfs-zlib.patch
  ];

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
