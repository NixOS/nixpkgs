{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nanosaur2";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UY+fyn8BA/HfCd2LCj5cfGmQACKUICH6CDCW4q6YDkg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    SDL2
  ];

  configurePhase = ''
    runHook preConfigure
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mv build $out
    makeWrapper $out/Nanosaur2 $out/bin/Nanosaur2 --chdir "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Nanosaur2, a 2004 Macintosh game by Pangea Software, for modern operating systems";
    longDescription = ''
      Nanosaur is a 2004 Macintosh game by Pangea Software.

      Is a continuation of the original Nanosaur storyline, only this time you get to fly a pterodactyl who’s loaded with hi-tech weaponry.
    '';
    homepage = "https://github.com/jorio/Nanosaur2";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}
