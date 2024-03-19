{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2024-03-17";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "7d662ad5c5e6cc33162034f6191f97394bdc9d6b";
    hash = "sha256-fJ05NC5N/90qLWuBR7RcrH5U4615MBAZEiVwg6JZp24=";
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
