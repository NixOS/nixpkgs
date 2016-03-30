{ stdenv, fetchurl
, boost, freeglut, glew, gsl, lcms2, libpng, libtiff, mesa, vigra
, help2man, pkgconfig, perl, tetex }:

stdenv.mkDerivation rec {
  name = "enblend-enfuse-${version}";
  version = "4.2";

  src = fetchurl {
    url = "mirror://sourceforge/enblend/${name}.tar.gz";
    sha256 = "0j5x011ilalb47ssah50ag0a4phgh1b0wdgxdbbp1gcyjcjf60w7";
  };

  buildInputs = [ boost freeglut glew gsl lcms2 libpng libtiff mesa vigra ];

  nativeBuildInputs = [ help2man perl pkgconfig tetex ];

  preConfigure = ''
    patchShebangs src/embrace
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://enblend.sourceforge.net/;
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nckx ];
  };
}
