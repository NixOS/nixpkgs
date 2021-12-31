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
  version = "3.0.0";

  gmic-community = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic-community";
    rev = "df23b08bc52767762f0e38d040cd8ffeea4b865e";
    sha256 = "euk5RsFPBgx2czAukPRdi/O4ahgXO8J8VJdiGHNge5M=";
  };

  CImg = fetchFromGitHub {
    owner = "dtschump";
    repo = "CImg";
    rev = "v.${version}";
    sha256 = "dC4VuWTz0uyFxLjBQ+2ggndHaCErcoI7tJMfkqbWmeg=";
  };

  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    url = "http://gmic.eu/gmic_stdlib${lib.replaceStrings ["."] [""] version}.h";
    sha256 = "CAYSxw5NCmE29hie1/J1csBcdQvIrmZ/+mNMl0sLLGI=";
  };

  gmic = fetchFromGitHub {
    owner = "dtschump";
    repo = "gmic";
    rev = "v.${version}";
    sha256 = "PyeJmjOqjbHlZ1Xl3IpoOD6oZEcUrHNHqF7Ft1RZDL4=";
  };

  gmic_qt = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${version}";
    sha256 = "nENXumOArRAHENqnBUjM7m+I5hf/WAFTVfm6cJgnv+0=";
  };

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

  unpackPhase = ''
    cp -r ${gmic} gmic
    ln -s ${gmic-community} gmic-community
    cp -r ${gmic_qt} gmic_qt
    chmod -R +w gmic gmic_qt
    ln -s ${CImg} CImg

    cp ${gmic_stdlib} gmic/src/gmic_stdlib.h

    cd gmic_qt
  '';

  postFixup = lib.optionalString (variant == "gimp") ''
    echo "wrapping $out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
    wrapQtApp "$out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
  '';

  passthru = {
    updateScript = writeShellScript "${pname}-update-script" ''
      set -o errexit
      PATH=${lib.makeBinPath [ common-updater-scripts curl gnugrep gnused coreutils jq ]}

      latestVersion=$(curl 'https://gmic.eu/files/source/' | grep -E 'gmic_[^"]+\.tar\.gz' | sed -E 's/.+<a href="gmic_([^"]+)\.tar\.gz".+/\1/g' | sort --numeric-sort --reverse | head -n1)

      if [[ "${version}" = "$latestVersion" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      # gmic-community is not versioned so let’s just update to master.
      communityLatestCommit=$(curl "https://api.github.com/repos/dtschump/gmic-community/commits/master")
      communityLatestSha=$(echo "$communityLatestCommit" | jq .sha --raw-output)
      communityLatestDate=$(echo "$communityLatestCommit" | jq .commit.committer.date --raw-output | sed 's/T.\+//')
      update-source-version --source-key=gmic-community "gmic-qt" "unstable-$communityLatestDate" --rev="$communityLatestSha"

      for component in CImg gmic_stdlib gmic gmic_qt; do
          # The script will not perform an update when the version attribute is up to date from previous platform run
          # We need to clear it before each run
          update-source-version "--source-key=$component" "gmic-qt" 0 "$(printf '0%.0s' {1..64})"
          update-source-version "--source-key=$component" "gmic-qt" $latestVersion
      done
    '';
  };

  meta = with lib; {
    description = variants.${variant}.description;
    homepage = "http://gmic.eu/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
