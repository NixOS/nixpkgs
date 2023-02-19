{ lib
, mkDerivation
, variant ? "standalone"
, fetchFromGitHub
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
, cimg
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

  src = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256 = "sha256-z+GtYLBcHVufXwdeSd8WKmPmU1+/EKMv26kNaEgyt5w=";
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
    # Broken since 3.2.0 update, cannot handle system gmic and cimg.
    broken = true;
    description = variants.${variant}.description;
    homepage = "http://gmic.eu/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
