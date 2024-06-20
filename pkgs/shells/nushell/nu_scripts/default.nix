{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "0-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "92f20ff2827b1afb3d06011bc0609a0212c53993";
    hash = "sha256-ZYrlX8Kg9VD5/eUctesAXQlBcVPiOZ3W9WCpBkByrpA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Place to share Nushell scripts with each other";
    homepage = "https://github.com/nushell/nu_scripts";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
