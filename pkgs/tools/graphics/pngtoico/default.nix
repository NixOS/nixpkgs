{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "pngtoico-1.0";

  src = fetchurl {
    url = mirror://kernel/software/graphics/pngtoico/pngtoico-1.0.tar.gz;
    sha256 = "1xb4aa57sjvgqfp01br3dm72hf7q0gb2ad144s1ifrs09215fgph";
  };

  configurePhase = ''
    sed -i s,/usr/local,$out, Makefile
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = http://www.kernel.org/pub/software/graphics/pngtoico/;
    description = "Small utility to convert a set of PNG images to Microsoft ICO format";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
  };
}
