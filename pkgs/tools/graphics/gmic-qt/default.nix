{ lib
, mkDerivation
, fetchurl
, variant ? "standalone"
, fetchFromGitHub
, cmake
, pkg-config
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
  pname = "gmic-qt${lib.optionalString (variant != "standalone") "-${variant}"}";
  version = "2.9.6";

  gmic-community = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic-community";
    rev = "be3064bc3427b074526d8f87e328512c3b6a5d77";
    sha256 = "b/lhjkJbgKEAY6IkgURu9A+8+9jSuVICVcTTnH44E8g=";
  };

  CImg = fetchFromGitHub {
    owner = "dtschump";
    repo = "CImg";
    rev = "v.${version}";
    sha256 = "RdOfog5FOw5XESyDFX68Lb2MUyCeUuPaq/0UVNTjNKo=";
  };

  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    url = "http://gmic.eu/gmic_stdlib${lib.replaceStrings ["."] [""] version}.h";
    sha256 = "h6PNWJhLz9Cs8JtWwXajSAq+vwQyCwuz5UN9jb1NKoA=";
  };

  gmic = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic";
    rev = "v.${version}";
    sha256 = "U5ARZCml6+AfWTg6GVUfuoBTktA6jzLjjclBO4gqj2Y=";
  };

  gmic_qt = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256 = "nLxgCJ/+VIKD3dg4YFdGh1GhMyyytGTRrY6KljJK6N0=";
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

  nativeBuildInputs = [
    cmake
    pkg-config
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
    homepage = "http://gmic.eu/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
