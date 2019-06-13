{ stdenv, fetchurl, cmake, ninja, pkgconfig
, opencv, openexr, graphicsmagick, fftw, zlib, libjpeg, libtiff, libpng
, withGimpPlugin ? true, gimp ? null}:

assert withGimpPlugin -> gimp != null;

let
  version = "2.2.2";

  # CMakeLists.txt is missing from the tarball and Makefile is terrible
  CMakeLists = fetchurl {
    url = "https://github.com/dtschump/gmic/raw/v.${version}/CMakeLists.txt";
    sha256 = "0lv5jrg98cpbk13fl4xm7l4sk1axfz054q570bpi741w815d7cpg";
  };
in stdenv.mkDerivation rec {
  name = "gmic-${version}";

  outputs = [ "out" "lib" "dev" "man" ] ++ stdenv.lib.optional withGimpPlugin "gimpPlugin";

  src = fetchurl {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    sha256 = "0zqfj2ym5nn3ff93xh2wf9ayxqlznabbdi00xw4lm7vw3iwkzqnc";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig ];

  buildInputs = [
    fftw zlib libjpeg libtiff libpng opencv openexr graphicsmagick
  ] ++ stdenv.lib.optionals withGimpPlugin [ gimp gimp.gtk ];

  cmakeFlags = [
    "-DBUILD_LIB_STATIC=OFF"
    "-DBUILD_PLUGIN=${if withGimpPlugin then "ON" else "OFF"}"
    "-DENABLE_DYNAMIC_LINKING=ON"
  ] ++ stdenv.lib.optional withGimpPlugin "-DPLUGIN_INSTALL_PREFIX=${placeholder "gimpPlugin"}/${gimp.targetPluginDir}";

  postPatch = ''
    cp ${CMakeLists} CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "G'MIC is an open and full-featured framework for image processing";
    homepage = http://gmic.eu/;
    license = licenses.cecill20;
    platforms = platforms.unix;
  };
}
