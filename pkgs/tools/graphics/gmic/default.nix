{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, cmake
, ninja
, pkg-config
, opencv
, openexr
, graphicsmagick
, cimg
, fftw
, zlib
, libjpeg
, libtiff
, libpng
, writeShellScript
, common-updater-scripts
, curl
, gnugrep
, gnused
, coreutils
, jq
, gmic-qt
}:

stdenv.mkDerivation rec {
  pname = "gmic";
  version = "3.2.3";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "GreycLab";
    repo = "gmic";
    rev = "v.${version}";
    hash = "sha256-slEyZoYSNFrZ0d8a+mnJeqWQLqcJTPrkfpDpdag/vLA=";
  };

  # TODO: build this from source
  # https://github.com/dtschump/gmic/blob/b36b2428db5926af5eea5454f822f369c2d9907e/src/Makefile#L675-L729
  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    url = "http://gmic.eu/gmic_stdlib${lib.replaceStrings ["."] [""] version}.h";
    hash = "sha256-ExMCxFkkctqrdSy5M/TXD5GBRmRA9YEdsYW8nWiTEYY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    cimg
    fftw
    zlib
    libjpeg
    libtiff
    libpng
    opencv
    openexr
    graphicsmagick
  ];

  cmakeFlags = [
    "-DBUILD_LIB_STATIC=OFF"
    "-DENABLE_CURL=OFF"
    "-DENABLE_DYNAMIC_LINKING=ON"
    "-DUSE_SYSTEM_CIMG=ON"
  ];

  postPatch = ''
    # TODO: build from source
    cp -r ${gmic_stdlib} src/gmic_stdlib.h

    # CMake build files were moved to subdirectory.
    mv resources/CMakeLists.txt resources/cmake .
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "LD_LIBRARY_PATH" "DYLD_LIBRARY_PATH"
  '';

  passthru = {
    tests = {
      # Needs to update in lockstep.
      inherit gmic-qt;
    };

    updateScript = writeShellScript "${pname}-update-script" ''
      set -o errexit
      PATH=${lib.makeBinPath [ common-updater-scripts curl gnugrep gnused coreutils jq ]}

      latestVersion=$(curl 'https://gmic.eu/files/source/' | grep -E 'gmic_[^"]+\.tar\.gz' | sed -E 's/.+<a href="gmic_([^"]+)\.tar\.gz".+/\1/g' | sort --numeric-sort --reverse | head -n1)

      if [[ "${version}" = "$latestVersion" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for component in src gmic_stdlib; do
          # The script will not perform an update when the version attribute is up to date from previous platform run
          # We need to clear it before each run
          update-source-version "--source-key=$component" "gmic" 0 "${lib.fakeHash}"
          update-source-version "--source-key=$component" "gmic" $latestVersion
      done
    '';
  };

  meta = with lib; {
    description = "Open and full-featured framework for image processing";
    homepage = "https://gmic.eu/";
    license = licenses.cecill21;
    maintainers = [ maintainers.lilyinstarlight ];
    platforms = platforms.unix;
  };
}
