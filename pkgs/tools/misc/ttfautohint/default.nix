{ stdenv, fetchurl, harfbuzz, pkgconfig, qt4 }:

stdenv.mkDerivation rec {
  version = "1.6";
  name = "ttfautohint-${version}";
  
  src = fetchurl {
    url = "mirror://savannah/freetype/${name}.tar.gz";
    sha256 = "1r8vsznvh89ay35angxp3w1xljxjlpcv9wdjyn7m61n323vi6474";
  };
  
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ harfbuzz qt4 ];

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
    maintainers = with maintainers; [ goibhniu ndowens ];
    platforms = platforms.linux;
  };

}
