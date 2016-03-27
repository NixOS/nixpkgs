{ stdenv, fetchurl
, boost, freeglut, glew, gsl, lcms2, libpng, libtiff, libxmi, mesa, vigra
, help2man, pkgconfig, perl }:

let version = "4.1.5"; in
stdenv.mkDerivation rec {
  name = "enblend-enfuse-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/enblend/${name}.tar.gz";
    sha256 = "08dz73jgrwfhz0kh57kz048qy1c6a35ckqn9xs5rajm449vnw0pg";
  };

  buildInputs = [ boost freeglut glew gsl lcms2 libpng libtiff libxmi mesa vigra ];

  nativeBuildInputs = [ help2man perl pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    inherit version;
    homepage = http://enblend.sourceforge.net/;
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = stdenv.lib.licenses.gpl2;
  };
}
