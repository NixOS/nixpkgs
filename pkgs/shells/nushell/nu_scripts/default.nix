{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "0-unstable-2024-04-30";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "4eab7ea772f0a288c99a79947dd332efc1884315";
    hash = "sha256-rXEtn0mO0hEH1zuDJ9vzsAeZfHnw9mkitzMqr7o5UYs=";
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
