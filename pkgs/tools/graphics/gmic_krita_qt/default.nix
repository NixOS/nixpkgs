{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig
, opencv, openexr, graphicsmagick, fftw, zlib, libjpeg, libtiff, libpng
, curl, krita, qtbase, qttools
, fetchgit }:

let
  version = "2.3.6";

in stdenv.mkDerivation rec {
  pname = "gmic_krita_qt";
  inherit version;

  gmic-community = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic-community";
    rev = "3fd528f20a2a7d651e96078c205ff21efb9cdd1a";
    sha256 = "08d37b49qgh5d4rds7hvr5wjj4p1y8cnbidz1cyqsibq0555pwq2";
  };

  CImg = fetchgit {
    url = "https://framagit.org/dtschump/CImg";
    rev = "90f5657d8eab7b549ef945103ef680e747385805";
    sha256 = "1af3dwqq18dkw0lz2gvnlw8y0kc1cw01hnc72rf3pg2wyjcp0pvc";
  };

  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    # Version should e in sync with gmic. Basically the version string without dots
    url = "http://gmic.eu/gmic_stdlib236.h";
    sha256 = "0q5g87dsn9byd2qqsa9xrsggfb9qv055s3l2gc0jrcvpx2qbza4q";
  };

  gmic = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic";
    rev = "v.${version}";
    sha256 = "1yg9ri3n07drv8gz4x0mn39ryi801ibl26jaza47m19ma893m8fi";
  };

  gmic_qt = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256= "0j9wqlq67dwzir36yg58xy5lbblwizvgcvlmzcv9d6l901d5ayf3";
  };

  unpackPhase = ''
    cp -r ${gmic} gmic
    ln -s ${gmic-community} gmic-community
    cp -r ${gmic_qt} gmic_qt
    chmod -R +w gmic gmic_qt
    ln -s ${CImg} CImg

    cp ${gmic_stdlib} gmic/src/gmic_stdlib.h

    cd gmic_qt
  '';

  preConfigure = ''
    make -C ../gmic/src CImg.h gmic_stdlib.h
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qtbase qttools fftw zlib libjpeg libtiff libpng
    opencv openexr graphicsmagick curl krita
  ];

  cmakeFlags = [ "-DGMIC_QT_HOST=krita" ];

  installPhase = ''
    mkdir -p $out/bin;
    install -Dm755 gmic_krita_qt "$out/bin/gmic_krita_qt"
  '';

  meta = with stdenv.lib; {
    description = "Krita plugin for the G'MIC image processing framework";
    homepage = http://gmic.eu/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
