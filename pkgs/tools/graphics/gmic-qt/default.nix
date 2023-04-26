{ lib
, stdenv
, variant ? "standalone"
, fetchzip
, cmake
, pkg-config
, ninja
, wrapQtAppsHook
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

stdenv.mkDerivation rec {
  pname = "gmic-qt${lib.optionalString (variant != "standalone") "-${variant}"}";
  version = "3.2.3";

  src = fetchzip {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    hash = "sha256-OTdf9BtaRak/jv1GknidDAkdxf99saBqj6EMoRJDIuo=";
  };

  sourceRoot = "source/gmic-qt";

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    wrapQtAppsHook
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
    maintainers = [ maintainers.lilyinstarlight ];
    platforms = platforms.unix;
    mainProgram = "gmic_qt";
  };
}
