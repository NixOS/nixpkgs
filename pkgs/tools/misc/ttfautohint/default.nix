{ stdenv, fetchurl, harfbuzz, pkgconfig, qt4 }:

stdenv.mkDerivation rec {
  version = "1.3";
  name = "ttfautohint-${version}";
  
  src = fetchurl {
    url = "mirror://savannah/freetype/${name}.tar.gz";
    sha256 = "01719jgdzgf0m4fzkkij563iksr40c7wydv1yq8ygpxjj0vs17y3";
  };

  buildInputs = [ harfbuzz pkgconfig qt4 ];

  meta = with stdenv.lib; {
    description = "An automatic hinter for TrueType fonts";
    longDescription = ''
      A library and two programs which take a TrueType font as the
      input, remove its bytecode instructions (if any), and return a
      new font where all glyphs are bytecode hinted using the
      information given by FreeType’s auto-hinting module.
    '';
    homepage = http://www.freetype.org/ttfautohint/;
    license = licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };

}
