{ lib
, mkDerivation
, fetchurl
, fetchpatch
, variant ? "standalone"
, fetchFromGitHub
, fetchFromGitLab
, cmake
, pkgconfig
, opencv3
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
  version = "2.7.1";

  gmic-community = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic-community";
    rev = "3fd528f20a2a7d651e96078c205ff21efb9cdd1a";
    sha256 = "08d37b49qgh5d4rds7hvr5wjj4p1y8cnbidz1cyqsibq0555pwq2";
  };

  CImg = fetchFromGitLab {
    domain = "framagit.org";
    owner = "dtschump";
    repo = "CImg";
    rev = "v.${version}";
    sha256 = "1mfkjvf5r3ppc1dd6yvqn7xlhgzfg9k1k5v2sq2k9m70g8p7rgpd";
  };

  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    url = "http://gmic.eu/gmic_stdlib${lib.replaceStrings ["."] [""] version}.h";
    sha256 = "0v12smknr1s44s6wq2gbnw0hb98xrwp6i3zg9wf49cl7s9qf76j3";
  };

  gmic = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic";
    rev = "v.${version}";
    sha256 = "0pa6kflr1gqgzh8rk7bylvkxs989r5jy0q7b62mnzx8895slwfb5";
  };

  gmic_qt = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256 = "08a0660083wv5fb1w9qqhm4f8cfwbqq723qzqq647mid1n7sy959";
  };

  patches = [
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
    opencv3
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
