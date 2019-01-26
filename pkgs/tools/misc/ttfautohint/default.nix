{
  stdenv, lib, fetchurl, pkgconfig, autoreconfHook
, freetype, harfbuzz, libiconv, qtbase
, enableGUI ? true
}:

stdenv.mkDerivation rec {
  version = "1.8.2";
  name = "ttfautohint-${version}";

  src = fetchurl {
    url = "mirror://savannah/freetype/${name}.tar.gz";
    sha256 = "19w9g1ksr0vyblgcirppj0279gfj5s902jblzgav5a4n2mq42rrq";
  };

  postAutoreconf = ''
    substituteInPlace configure --replace "macx-g++" "macx-clang"
  '';

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ freetype harfbuzz libiconv ] ++ lib.optional enableGUI qtbase;

  configureFlags = [ ''--with-qt=${if enableGUI then "${qtbase}/lib" else "no"}'' ];

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
