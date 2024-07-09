{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "package-project-cmake";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "TheLartians";
    repo = "PackageProject.cmake";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2u7H2ZR7eQ6eoRIVZ1WBxw9K93E8BVYErZNDe1Jl8rg=";
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
    description = "CMake script for packaging C/C++ projects";
    longDescription = ''
      Help other developers use your project. A CMake script for packaging
      C/C++ projects for simple project installation while employing
      best-practices for maximum compatibility. Creating installable
      CMake scripts always requires a large amount of boilerplate code
      to get things working. This small script should simplify the CMake
      packaging process into a single, easy-to-use command.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
})
