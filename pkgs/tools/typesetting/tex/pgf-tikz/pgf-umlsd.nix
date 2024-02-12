{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation {
  pname = "pgf-umlcd";
  version = "unstable-2020-05-28";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf-umlsd";
    rev = "8766cc18596dbfa66202ceca01c62cab1c3ed6a2";
    hash = "sha256-gSBO7uDPMer9XyHfs0rr+2lricN5Nb4cOlShCsk0cPc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd doc tex/latex $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pgf-tikz/pgf-umlsd";
    description = "Some LaTeX macros for UML Sequence Diagrams";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
