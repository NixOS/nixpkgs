{ stdenv, fetchurl, fetchFromGitHub, cmake, ninja, pkgconfig, qt5
, opencv, openexr, graphicsmagick, fftw, zlib, libjpeg, libtiff, libpng
, withGimpPlugin ? true, gimp ? null}:

assert withGimpPlugin -> gimp != null;

let
  version = "2.3.6";

  gmic-version = "2.3.6";

  # CMakeLists.txt is missing from the tarball and Makefile is terrible
  #CMakeLists = fetchurl {
  #  url = "https://github.com/dtschump/gmic/raw/v.${version}/CMakeLists.txt";
  #  sha256 = "0lv5jrg98cpbk13fl4xm7l4sk1axfz054q570bpi741w815d7cpg";
  #};
in stdenv.mkDerivation rec {
  name = "gmic-qt-${version}";

  srcs = [
    (fetchFromGitHub {
      owner = "dtschump";
      repo = "gmic";
      rev = "3e9600c5c99cca3b389099909fc3a231e0a69d8e";
      sha256 = "1yg9ri3n07drv8gz4x0mn39ryi801ibl26jaza47m19ma893m8fi";})
    (fetchFromGitHub {
      owner = "c-koi";
      repo = "gmic-qt";
      rev = "9e992cff2db418032b849458f5c9443267c7162c";
      sha256= "0j9wqlq67dwzir36yg58xy5lbblwizvgcvlmzcv9d6l901d5ayf3";})
  ];

  sourceRoot = "gmic-${gmic-version}";

  #src = fetchgit {
  #  url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
  #  sha256 = "0zqfj2ym5nn3ff93xh2wf9ayxqlznabbdi00xw4lm7vw3iwkzqnc";
  #};

  nativeBuildInputs = [ qt5.qmake ];

  buildInputs = [
    fftw zlib libjpeg libtiff libpng opencv openexr graphicsmagick
  ];

  #cmakeFlags = [
  #  "-DBUILD_LIB_STATIC=OFF"
  #  "-DBUILD_PLUGIN=${if withGimpPlugin then "ON" else "OFF"}"
  #  "-DENABLE_DYNAMIC_LINKING=ON"
  #] ++ stdenv.lib.optional withGimpPlugin "-DPLUGIN_INSTALL_PREFIX=${placeholder "gimpPlugin"}/${gimp.targetPluginDir}";

  #postPatch = ''
  #  cp ${CMakeLists} CMakeLists.txt
  #'';

  buildPhase = ''
    make -C src CImg.h gmic_stdlib.h;
    cd ../qmic-qt;
    mkdir build;
    qmake HOST=krita ..;
    make
  '';

  installPhase = ''
    mkdir -p $out/bin;
    install -Dm755 "gmic-qt/gmic_krita_qt" "$out/gmic_krita_qt"
  '';

  meta = with stdenv.lib; {
    description = "Krita plugin for the G'MIC image processing framework";
    homepage = http://gmic.eu/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
