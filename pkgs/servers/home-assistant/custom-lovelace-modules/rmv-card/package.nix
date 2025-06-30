{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "rmv-card";
  version = "0-unstable-2023-10-09";

  src = fetchFromGitHub {
    owner = "custom-cards";
    repo = "rmv-card";
    rev = "b0b2af1565bb69b8d304285cae163cb15883c9ab";
    hash = "sha256-9chkS4wqkeNqeYGWdG00bwJOdDbsI+9VwWWfH+5TJoY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp rmv-card.js $out/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Custom card for the RMV component";
    homepage = "https://github.com/custom-cards/rmv-card";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.all;
  };
}
