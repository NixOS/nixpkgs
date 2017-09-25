{ stdenv, fetchurl, cmake, pkgconfig, openexr, ilmbase, zlib, imagemagick, mesa, freeglut, fftwFloat, fftw, gsl, libexif, perl, opencv, qt4 }:

stdenv.mkDerivation rec {
  name = "pfstools";
  version = "2.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${version}/${name}-${version}.tgz";
    sha256 = "1fyc2c7jzr7k797c2dqyyvapzc3szxwcp48r382yxz2yq558xgd9";
  };

  outputs = [ "out" "dev" "man"];

  cmakeFlags = ''
    -DWITH_MATLAB=false 
  '';

  buildInputs = [ openexr zlib imagemagick mesa freeglut fftwFloat fftw gsl libexif perl opencv qt4 ];

  nativeBuildInputs = [ cmake pkgconfig ];

  patches = [ ./threads.patch ./pfstools.patch ];

  meta = with stdenv.lib; {
    homepage = http://pfstools.sourceforge.net/;
    description = "Toolkit for manipulation of HDR images";
    platforms = platforms.linux;
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}
