 { stdenv, fetchurl, pkgconfig, freetype, gtk }:

stdenv.mkDerivation rec {
  version = "1.6";
  name = "gbdfed-${version}";

  src = fetchurl {
    url = "http://sofia.nmsu.edu/~mleisher/Software/gbdfed/${name}.tar.bz2";
    sha256 = "0g09k6wim58hngxncq2brr7mwjm92j3famp0vs4b3p48wr65vcjx";
  };

  buildInputs = [ pkgconfig freetype gtk ];

  patches = [ ./Makefile.patch ];

  meta = {
    description = "Bitmap Font Editor";
    longDescription = ''
      gbdfed lets you interactively create new bitmap font files or modify existing ones.
      It allows editing multiple fonts and multiple glyphs, 
      it allows cut and paste operations between fonts and glyphs and editing font properties.
      The editor works natively with BDF fonts. 
    '';
    homepage = http://sofia.nmsu.edu/~mleisher/Software/gbdfed/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.linquize ];
    platforms = stdenv.lib.platforms.all;
  };
}
