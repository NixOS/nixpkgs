{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "pngcrush-1.7.50";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/${name}-nolib.tar.xz";
    sha256 = "1xabqjgvwsyazs0hw7bzzm256zbd7v33alwzp0lbawm521m3m651";
  };

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = http://pmt.sourceforge.net/pngcrush;
    description = "A PNG optimizer";
    license = "free";
    platforms = with stdenv.lib.platforms; linux;
  };
}
