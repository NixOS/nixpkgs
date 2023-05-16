{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cpm-cmake";
<<<<<<< HEAD
  version = "0.38.2";
=======
  version = "0.38.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cpm-cmake";
    repo = "cpm.cmake";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-/qractCyItq1dNc8rBoipwmt4SGkdylxHu0Lnt4Jb/Q=";
=======
    hash = "sha256-gH12lO8XiSlPHyifJeaZ5mdk8ylIbLYTKKkitTK4jCA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{,doc/}cpm
    install -Dm644 cmake/CPM.cmake $out/share/cpm/CPM.cmake
    install -Dm644 README.md CONTRIBUTING.md $out/share/doc/cpm/

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
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
})
