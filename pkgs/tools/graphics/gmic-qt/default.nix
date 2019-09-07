{ lib
, mkDerivation
, fetchurl
, fetchpatch
, variant ? "standalone"
, fetchFromGitHub
, cmake
, pkgconfig
, opencv
, openexr
, graphicsmagick
, fftw
, zlib
, libjpeg
, libtiff
, libpng
, curl
, krita ? null
, gimp ? null
, qtbase
, qttools
, fetchgit
}:

let
  variants = {
    gimp = {
      extraDeps = [
        gimp
        gimp.gtk
      ];
      description = "GIMP plugin for the G'MIC image processing framework";
    };

    krita = {
      extraDeps = [
        krita
      ];
      description = "Krita plugin for the G'MIC image processing framework";
    };

    standalone = {
      description = "Versatile front-end to the image processing framework G'MIC";
    };
  };

in

assert lib.assertMsg (builtins.hasAttr variant variants) "gmic-qt variant “${variant}” is not supported. Please use one of ${lib.concatStringsSep ", " (builtins.attrNames variants)}.";

assert lib.assertMsg (builtins.all (d: d != null) variants.${variant}.extraDeps or []) "gmic-qt variant “${variant}” is missing one of its dependencies.";

mkDerivation rec {
  pname = "gmic-qt${lib.optionalString (variant != "standalone") ''-${variant}''}";
  version = "2.3.6";

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
    sha256 = "0j9wqlq67dwzir36yg58xy5lbblwizvgcvlmzcv9d6l901d5ayf3";
  };

  patches = [
    # Add install targets
    (fetchpatch {
      url = https://github.com/c-koi/gmic-qt/commit/ec4babbaf06a8711a4fd841f7de4106cda765109.patch;
      sha256 = "1rim6vjx3k0yw8mplq8ampb2ykfabjj6d8vynmp8lm6n8id99yr0";
    })

    # Fix translations installation
    (fetchpatch {
      url = https://github.com/c-koi/gmic-qt/commit/91f92ba589d6559541d5dfacf39dab4e0faaa106.patch;
      sha256 = "1kh39349qcna386lx80kgj87xxlyh95xmwnv539z4zqnpzyqdxfs";
    })

    # Install GIMP plug-in to a correct destination
    # https://github.com/c-koi/gmic-qt/pull/78
    ./fix-gimp-plugin-path.patch
  ];

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

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    qtbase
    qttools
    fftw
    zlib
    libjpeg
    libtiff
    libpng
    opencv
    openexr
    graphicsmagick
    curl
  ] ++ variants.${variant}.extraDeps or [];

  cmakeFlags = [
    "-DGMIC_QT_HOST=${if variant == "standalone" then "none" else variant}"
  ];

  postFixup = lib.optionalString (variant == "gimp") ''
    echo "wrapping $out/${gimp.targetPluginDir}/gmic_gimp_qt"
    wrapQtApp "$out/${gimp.targetPluginDir}/gmic_gimp_qt"
  '';

  meta = with lib; {
    description = variants.${variant}.description;
    homepage = http://gmic.eu/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
