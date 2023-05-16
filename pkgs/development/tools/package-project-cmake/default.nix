{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "package-project-cmake";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "TheLartians";
    repo = "PackageProject.cmake";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-41cJm6eO5Q6xhARJbshi6Tesk/IxEQNsMShmDcjVqzs=";
=======
    hash = "sha256-tDjWknwqN8NLx6GX16WOn0JUDAyaGU9HA7fTsHNLx9s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{,doc/}package-project-cmake
    install -Dm644 CMakeLists.txt $out/share/package-project-cmake/
    install -Dm644 README.md $out/share/doc/package-project-cmake/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/TheLartians/PackageProject.cmake";
    description = "A CMake script for packaging C/C++ projects";
    longDescription = ''
      Help other developers use your project. A CMake script for packaging
      C/C++ projects for simple project installation while employing
      best-practices for maximum compatibility. Creating installable
      CMake scripts always requires a large amount of boilerplate code
      to get things working. This small script should simplify the CMake
      packaging process into a single, easy-to-use command.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ken-matsui ];
    platforms = platforms.all;
  };
})
