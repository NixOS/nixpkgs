{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "cpm";
  version = "0.35.1";

  src = fetchFromGitHub {
    owner = "cpm-cmake";
    repo = "CPM.cmake";
    rev = "v${version}";
    hash = "sha256-Oon/5iwkUUASsUDvde69iEwLe8/CAzwYKYsyzH5K+V0=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/cpm/
    cp ./cmake/CPM.cmake ${placeholder "out"}/share/cpm/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/cpm-cmake/CPM.cmake";
    description = "CMake's missing package manager";
    longDescription = ''
      CPM.cmake is a cross-platform CMake script that adds dependency
      management capabilities to CMake. It's built as a thin wrapper around
      CMake's FetchContent module that adds version control, caching, a
      simple API and more.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ken-matsui ];
    platforms = platforms.all;
  };
}
