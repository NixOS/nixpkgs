{ stdenv, fetchurl, cmake, pkgconfig, darwin
, openexr, zlib, imagemagick, libGLU, libGL, freeglut, fftwFloat
, fftw, gsl, libexif, perl, opencv, qt5, netpbm
}:

stdenv.mkDerivation rec {
  pname = "pfstools";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "04rlb705gmdiphcybf9dyr0d5lla2cfs3c308zz37x0vwi445six";
  };

  outputs = [ "out" "dev" "man"];

  cmakeFlags = [ "-DWITH_MATLAB=false" ];

  preConfigure = ''
    rm cmake/FindNETPBM.cmake
    echo "SET(NETPBM_LIBRARY `find ${stdenv.lib.getLib netpbm} -name "*.${stdenv.hostPlatform.extensions.sharedLibrary}*" -type f`)" >> cmake/FindNETPBM.cmake
    echo "SET(NETPBM_LIBRARIES `find ${stdenv.lib.getLib netpbm} -name "*.${stdenv.hostPlatform.extensions.sharedLibrary}*" -type f`)" >> cmake/FindNETPBM.cmake
    echo "SET(NETPBM_INCLUDE_DIR ${stdenv.lib.getDev netpbm}/include/netpbm)" >> cmake/FindNETPBM.cmake
    echo "INCLUDE(FindPackageHandleStandardArgs)" >> cmake/FindNETPBM.cmake
    echo "FIND_PACKAGE_HANDLE_STANDARD_ARGS(NETPBM DEFAULT_MSG NETPBM_LIBRARY NETPBM_INCLUDE_DIR)" >> cmake/FindNETPBM.cmake
  '';

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    openexr zlib imagemagick fftwFloat
    fftw gsl libexif perl opencv qt5.qtbase netpbm
  ] ++ (if stdenv.isDarwin then (with darwin.apple_sdk.frameworks; [
    OpenGL GLUT
  ]) else [
    libGLU libGL freeglut
  ]);

  patches = [ ./threads.patch ./pfstools.patch ./pfsalign.patch ];

  meta = with stdenv.lib; {
    homepage = http://pfstools.sourceforge.net/;
    description = "Toolkit for manipulation of HDR images";
    platforms = platforms.linux;
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}
