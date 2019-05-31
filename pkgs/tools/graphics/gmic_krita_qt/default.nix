{ stdenv, fetchurl, fetchFromGitHub, cmake, ninja, pkgconfig
, opencv, openexr, graphicsmagick, fftw, zlib, libjpeg, libtiff, libpng
, curl, krita, qtbase, qttools
, fetchgit }:

let
  version = "2.6.4";

in stdenv.mkDerivation rec {
  name = "gmic_krita_qt-${version}";

  gmic-community = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic-community";
    rev = "011f7ec229c279d820f332eb1f64b913e152aff2";
    sha256 = "0gya9kk36jrbs99s5qhrwziifhkvwv31zr8x9gzfmahbb753bj9r";
  };

  CImg = fetchgit {
    url = "https://framagit.org/dtschump/CImg";
    rev = "v.${version}";
    sha256 = "100lh85l3rh0w3dmy2qmfwlmx85h18xzr11znnx571nqf2zdmbmk";
  };

  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    # Version should be in sync with gmic. Basically the version string without dots
    url = "http://gmic.eu/gmic_stdlib${builtins.replaceStrings [ "." ] [ "" ] version}.h";
    sha256 = "1i2jm4bih0mvvah7rj6a0rk6hdw0cmdmdzkbvj67qbplyin5k2kf";
  };

  gmic = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic";
    rev = "v.${version}";
    sha256 = "0rcg9h1wig02263yh5gp77gdp97fr4hvf8nd71x43yzwnq47zma9";
  };

  gmic_qt = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256= "1lffypx1d77vylgh6r0v6wf5d9jmfx0szbzd510i44fzkdismpdl";
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
