{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation rec {
  pname = "cpm";
  version = "0.35.1";

  src = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${version}/CPM.cmake";
    sha256 = "sha256-CMge+NpJRU+G+c+s0tb2EN8UG6E8FE90lIvcULggYXY=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/cpm/CPM.cmake

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
