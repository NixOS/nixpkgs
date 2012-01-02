{ stdenv, fetchurl, libpng, xz }:

stdenv.mkDerivation rec {
  name = "pngcrush-1.7.22";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/${name}-nolib.tar.xz";
    sha256 = "1sngz34cssni4j7hvqhq5ms6h4ydb3b0s5y7fidv3kjms9g1xcsp";
  };

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ libpng ];
  buildNativeInputs = [ xz ];

  meta = {
    homepage = http://pmt.sourceforge.net/pngcrush;
    description = "A PNG optimizer";
    license = "free";
    platforms = with stdenv.lib.platforms; linux;
  };
}
