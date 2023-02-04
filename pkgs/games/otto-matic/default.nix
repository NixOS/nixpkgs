{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "OttoMatic";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = version;
    sha256 = "sha256-eHy5yED5qrgHqKuqq1dXhmuR2PQBE5aMhSLPoydlpPk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    SDL2
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv OttoMatic Data ReadMe.txt "$out/"
    makeWrapper $out/OttoMatic $out/bin/OttoMatic --chdir "$out"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Otto Matic, a 2001 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/OttoMatic";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}
