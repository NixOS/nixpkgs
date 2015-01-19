{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "pngcrush-1.7.82";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/${name}-nolib.tar.xz";
    sha256 = "1cxg0a6x7sq0dh9ia8isgx3awwx1db96wq4n22rs31sm3niiw0fl";
  };

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = http://pmt.sourceforge.net/pngcrush;
    description = "A PNG optimizer";
    license = stdenv.lib.licenses.free;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
