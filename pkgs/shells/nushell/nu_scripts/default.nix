{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-07-29";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "3ee56c6ec31fcc8dbffee85e1c73eb6fe0bbba8d";
    hash = "sha256-luGIvcKOfhDorPfGfL449+eD+58MGo5jMCsNwIRJWt4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A place to share Nushell scripts with each other";
    homepage = "https://github.com/nushell/nu_scripts";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
