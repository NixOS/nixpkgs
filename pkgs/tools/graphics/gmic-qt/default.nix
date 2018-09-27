{ stdenv, fetchurl, fetchFromGitHub, cmake, ninja, pkgconfig, qt5
, opencv, openexr, graphicsmagick, fftw, zlib, libjpeg, libtiff, libpng
, curl, krita, gdk_pixbuf, cairo
, fetchgit, withGimpPlugin ? true, gimp }:

let
  version = "2.3.6";

  gmic-version = "2.3.6";

in stdenv.mkDerivation rec {
  name = "gmic-qt-${version}";

  gmic-community = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic-community";
    rev = "3fd528f20a2a7d651e96078c205ff21efb9cdd1a";
    sha256 = "08d37b49qgh5d4rds7hvr5wjj4p1y8cnbidz1cyqsibq0555pwq2";
  };

  CImg = fetchgit {
    url = "https://framagit.org/dtschump/CImg";
    rev = "c523f0026f3b03831c0778335fe7c7661bf9a719";
    sha256 = "13ja8immpjkm2xskddc920axq2rp4hc2sr5ghgvgy1rshc3lp8i8";
  };

  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    url = "http://gmic.eu/gmic_stdlib236.h";
    sha256 = "0q5g87dsn9byd2qqsa9xrsggfb9qv055s3l2gc0jrcvpx2qbza4q";
  };

  gmic = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic";
    rev = "b9a6876684f40852ca39300c9d7e7d676cb81b14";
    sha256 = "0f69r460lyfb021m7bs8s4rxa3png51cbp1izywsy3sprjd1s57p";
  };

  gmic_qt = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "9e992cff2db418032b849458f5c9443267c7162c";
    sha256= "0j9wqlq67dwzir36yg58xy5lbblwizvgcvlmzcv9d6l901d5ayf3";
  };

  unpackPhase = ''
    cp -r ${gmic} gmic
    ln -s ${gmic-community} gmic-community
    cp -r ${gmic_qt} gmic_qt
    chmod -R +w gmic gmic_qt
    ln -s ${CImg} CImg

    cp ${gmic_stdlib} gmic/src/gmic_stdlib.h

    make -C gmic/src CImg.h gmic_stdlib.h
    cd gmic_qt
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase qt5.qttools gimp gdk_pixbuf fftw zlib libjpeg libtiff libpng
    opencv openexr graphicsmagick curl cairo krita
  ];

  cmakeFlags = [ "-DGMIC_QT_HOST=krita" ];

  installPhase = ''
    mkdir -p $out/bin;
    install -Dm755 gmic-qt/gmic_krita_qt "$out/gmic_krita_qt"
  '';

  meta = with stdenv.lib; {
    description = "Krita plugin for the G'MIC image processing framework";
    homepage = http://gmic.eu/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
