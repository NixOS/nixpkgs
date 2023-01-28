{ lib
, mkDerivation
, variant ? "standalone"
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, ninja
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
, gmic
, cimg
, qtbase
, qttools
, writeShellScript
, common-updater-scripts
, gnugrep
, gnused
, coreutils
, jq
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
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256 = "sha256-/5wDHvJSMgEheg8YV4W40wUiHz25emIoFnGdfO8i92g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    gmic
    cimg
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
    "-DENABLE_SYSTEM_GMIC:BOOL=ON"
  ];

  patches = [
    # NOTE: this should be removed when a new version is released.
    (fetchpatch {
      name = "fix_filter_translation_scripts.patch";
      url = "https://github.com/c-koi/gmic-qt/commit/ccb9f29eda239d0c80663593cd90a6548c935b39.patch";
      sha256 = "sha256-OzuJ6yGuDJweQ+1uin/pmJqZV79bN9E1Zuo+0iciwzg=";
    })
  ];

  postPatch = ''
    patchShebangs \
      translations/filters/csv2ts.sh \
      translations/lrelease.sh
  '';

  postFixup = lib.optionalString (variant == "gimp") ''
    echo "wrapping $out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
    wrapQtApp "$out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
  '';

  meta = with lib; {
    description = variants.${variant}.description;
    homepage = "http://gmic.eu/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
