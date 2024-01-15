{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2024-01-05";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "06327787549c41c93f8079cb034305d666479587";
    hash = "sha256-O7wBMsq1Ds5Re5PakxQoDNnJg0VOdz1yKKanv4Q42SA=";
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
