{ lib
, mkDerivation
, fetchurl
, fetchpatch
, variant ? "standalone"
, fetchFromGitHub
, fetchFromGitLab
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
, gmic
, qttools
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
  version = "2.7.5";

  # gmic-community = fetchFromGitHub {
  #   owner = "dtschump";
  #   repo = "gmic-community";
  #   rev = "3fd528f20a2a7d651e96078c205ff21efb9cdd1a";
  #   sha256 = "08d37b49qgh5d4rds7hvr5wjj4p1y8cnbidz1cyqsibq0555pwq2";
  # };

  # CImg = fetchFromGitLab {
  #   domain = "framagit.org";
  #   owner = "dtschump";
  #   repo = "CImg";
  #   rev = "v.${version}";
  #   sha256 = "19qmndmaj7wykbq590c5jy2qjgqhf17vq7f620gv40i6jwsfmw87";
  # };

  # gmic_stdlib = fetchurl {
  #   name = "gmic_stdlib.h";
  #   url = "http://gmic.eu/gmic_stdlib${lib.replaceStrings ["."] [""] version}.h";
  #   sha256 = "1brdhgss1yz09cwvjk4nnkgaxis0m26bpln4iq719fpax8z7xv3h";
  # };

  gmic_src = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic";
    rev = "v.${version}";
    sha256 = "1xh3mxmkjaqk36asrpammj1nwvjz3cc1l47bz44r80xfm7pimisy";
  };

  src = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256 = "1zn7wfs7zdmmm6nblnwrkhi14f1nlnvrg8k4d5g1myvd36rw0378";
  };

  patches = [
    # allow using system gmic
    (fetchpatch {
      url = "https://github.com/c-koi/gmic-qt/pull/81.patch";
      sha256 = "0a9y2ynj33pv40gpmz7zxdzn4qdk9nnl7wyxp8g0yn1n6jzfzbr4";
    })
  ];

  # unpackPhase = ''
  #   # cp -r ${gmic_src} gmic
  #   ln -s ${gmic-community} gmic-community
  #   cp -r ${gmic_qt} gmic_qt
  #   # chmod -R +w gmic gmic_qt
  #   chmod -R +w gmic_qt
  #   ln -s ${CImg} CImg

  #   # cp ${gmic_stdlib} gmic/src/gmic_stdlib.h

  #   cd gmic_qt
  # '';

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    qtbase
    gmic
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
    "-DGMIC_PATH=${gmic_src}/src"
    "-DENABLE_DYNAMIC_LINKING=ON"
    "-DENABLE_SYSTEM_GMIC=ON"
  ];

  # TODO: since we split gimp into multiple outputs, the pc file contains absolute paths
  PKG_CONFIG_GIMP_2_0_GIMPLIBDIR = "${placeholder "out"}/lib/gimp/2.0";

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
