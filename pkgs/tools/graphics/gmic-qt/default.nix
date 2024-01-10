{ lib
, stdenv
, fetchzip
, cimg
, cmake
, coreutils
, curl
, fftw
, gimp
, gimpPlugins
, gmic
, gnugrep
, gnused
, graphicsmagick
, libjpeg
, libpng
, libtiff
, ninja
, nix-update
, openexr
, pkg-config
, qtbase
, qttools
, wrapQtAppsHook
, writeShellScript
, zlib
, variant ? "standalone"
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

assert lib.assertMsg
  (builtins.hasAttr variant variants)
  "gmic-qt variant \"${variant}\" is not supported. Please use one of ${lib.concatStringsSep ", " (builtins.attrNames variants)}.";

assert lib.assertMsg
  (builtins.all (d: d != null) variants.${variant}.extraDeps or [])
  "gmic-qt variant \"${variant}\" is missing one of its dependencies.";

stdenv.mkDerivation (finalAttrs: {
  pname = "gmic-qt${lib.optionalString (variant != "standalone") "-${variant}"}";
  version = "3.3.2";

  src = fetchzip {
    url = "https://gmic.eu/files/source/gmic_${finalAttrs.version}.tar.gz";
    hash = "sha256-VaGYjCp1KVRTxEKzUdMCavZBIGEnEvP5fdFqQeKGa44=";
  };

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
    openexr
    graphicsmagick
    curl
  ] ++ variants.${variant}.extraDeps or [];

  preConfigure = ''
    cd gmic-qt
  '';

  postPatch = ''
    patchShebangs \
      translations/filters/csv2ts.sh \
      translations/lrelease.sh
  '';

  cmakeFlags = [
    (lib.cmakeFeature "GMIC_QT_HOST" (if variant == "standalone" then "none" else variant))
    (lib.cmakeBool "ENABLE_SYSTEM_GMIC" true)
    (lib.cmakeBool "ENABLE_DYNAMIC_LINKING" true)
  ];

  postFixup = lib.optionalString (variant == "gimp") ''
    echo "wrapping $out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
    wrapQtApp "$out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
  '';

  passthru = {
    tests = {
      gimp-plugin = gimpPlugins.gmic;
      # Needs to update them all in lockstep.
      inherit cimg gmic;
    };

    updateScript = writeShellScript "gmic-qt-update-script" ''
      set -euo pipefail

      export PATH="${lib.makeBinPath [ coreutils curl gnugrep gnused nix-update ]}:$PATH"

      latestVersion=$(curl 'https://gmic.eu/files/source/' \
                       | grep -E 'gmic_[^"]+\.tar\.gz' \
                       | sed -E 's/.+<a href="gmic_([^"]+)\.tar\.gz".+/\1/g' \
                       | sort --numeric-sort --reverse | head -n1)

      if [[ '${finalAttrs.version}' = "$latestVersion" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      nix-update --version "$latestVersion"
    '';
  };

  meta = {
    homepage = "http://gmic.eu/";
    inherit (variants.${variant}) description;
    license = lib.licenses.gpl3Plus;
    mainProgram = "gmic_qt";
    maintainers = [
      lib.maintainers.AndersonTorres
      lib.maintainers.lilyinstarlight
    ];
    platforms = lib.platforms.unix;
  };
})
