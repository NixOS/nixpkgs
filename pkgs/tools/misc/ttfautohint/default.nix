{ stdenv, lib, fetchurl, pkgconfig, freetype, harfbuzz, libiconv, qtbase, enableGUI ? true }:

stdenv.mkDerivation rec {
  version = "1.7";
  name = "ttfautohint-${version}";

  src = fetchurl {
    url = "mirror://savannah/freetype/${name}.tar.gz";
    sha256 = "1wh783pyg79ks5qbni61x7qngdhyfc33swrkcl5r1czdwhhlif9x";
  };

  postPatch = ''
    substituteInPlace configure --replace "macx-g++" "macx-clang"
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ freetype harfbuzz libiconv ] ++ lib.optional enableGUI qtbase;

  configureFlags = lib.optional (!enableGUI) "--with-qt=no";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An automatic hinter for TrueType fonts";
    longDescription = ''
      A library and two programs which take a TrueType font as the
      input, remove its bytecode instructions (if any), and return a
      new font where all glyphs are bytecode hinted using the
      information given by FreeType’s auto-hinting module.
    '';
    homepage = https://www.freetype.org/ttfautohint;
    license = licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    maintainers = with maintainers; [ goibhniu ndowens ];
    platforms = platforms.unix;
  };

}
