{ lib
, mkDerivation
, variant ? "standalone"
, fetchzip
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
, gimp ? null
, gmic
, qtbase
, qttools
, writeShellScript
, common-updater-scripts
, gnugrep
, gnused
, coreutils
, jq
, nix-update-script
, gimpPlugins
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

    standalone = {
      description = "Versatile front-end to the image processing framework G'MIC";
    };
  };

in

assert lib.assertMsg (builtins.hasAttr variant variants) "gmic-qt variant “${variant}” is not supported. Please use one of ${lib.concatStringsSep ", " (builtins.attrNames variants)}.";

assert lib.assertMsg (builtins.all (d: d != null) variants.${variant}.extraDeps or []) "gmic-qt variant “${variant}” is missing one of its dependencies.";

mkDerivation rec {
  pname = "gmic-qt${lib.optionalString (variant != "standalone") "-${variant}"}";
  version = "3.2.1";

  src = fetchzip {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    hash = "sha256-2lMnn19FcFKnfIjSxOObqxIjqLMUoWgi0ADZBCBePY4=";
  };

  patches = [
    (fetchpatch {
      name = "gmic-qt-3.2.1-fix-system-gmic.patch";
      url = "https://github.com/c-koi/gmic-qt/commit/e8d7a3523753ff592da63b1d54edf0921c54fe53.patch";
      hash = "sha256-kBFZo2qvod4pH3oK8gvnmw39x6eMH9zjr4mMcY74mFo=";
    })
  ];

  sourceRoot = "source/gmic-qt";

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    gmic
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
    "-DENABLE_SYSTEM_GMIC=ON"
    "-DENABLE_DYNAMIC_LINKING=ON"
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

  passthru = {
    tests = {
      gimp-plugin = gimpPlugins.gmic;
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = variants.${variant}.description;
    homepage = "http://gmic.eu/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
