{ lib, stdenv, mkDerivation, fetchurl, cmake, pkg-config, darwin
, openexr, zlib, imagemagick6, libGLU, libGL, libglut, fftwFloat
, fftw, gsl, libexif, perl, qtbase, netpbm
, enableUnfree ? false, opencv
}:

mkDerivation rec {
  pname = "pfstools";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "sha256-m/aESYVmMibCGZjutDwmGsuOSziRuakbcpVUQGKJ18o=";
  };

  outputs = [ "out" "dev" "man"];

  cmakeFlags = [ "-DWITH_MATLAB=false" ];

  preConfigure = ''
    sed -e 's|#include( ''${PROJECT_SRC_DIR}/cmake/FindNETPBM.cmake )|include( ''${PROJECT_SOURCE_DIR}/cmake/FindNETPBM.cmake )|' -i CMakeLists.txt

    rm cmake/FindNETPBM.cmake
    echo "SET(NETPBM_LIBRARY `find ${lib.getLib netpbm} -name "*${stdenv.hostPlatform.extensions.sharedLibrary}*" -type f`)" >> cmake/FindNETPBM.cmake
    echo "SET(NETPBM_LIBRARIES `find ${lib.getLib netpbm} -name "*${stdenv.hostPlatform.extensions.sharedLibrary}*" -type f`)" >> cmake/FindNETPBM.cmake
    echo "SET(NETPBM_INCLUDE_DIR ${lib.getDev netpbm}/include/netpbm)" >> cmake/FindNETPBM.cmake
    echo "INCLUDE(FindPackageHandleStandardArgs)" >> cmake/FindNETPBM.cmake
    echo "FIND_PACKAGE_HANDLE_STANDARD_ARGS(NETPBM DEFAULT_MSG NETPBM_LIBRARY NETPBM_INCLUDE_DIR)" >> cmake/FindNETPBM.cmake
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    openexr zlib imagemagick6 fftwFloat
    fftw gsl libexif perl qtbase netpbm
  ] ++ (if stdenv.hostPlatform.isDarwin then (with darwin.apple_sdk.frameworks; [
    OpenGL GLUT
  ]) else [
    libGLU libGL libglut
  ]) ++ lib.optional enableUnfree (opencv.override { enableUnfree = true; });

  patches = [ ./glut.patch ./threads.patch ./pfstools.patch ./pfsalign.patch ];

  meta = with lib; {
    homepage = "https://pfstools.sourceforge.net/";
    description = "Toolkit for manipulation of HDR images";
    platforms = platforms.linux;
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}
