{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "c2bb125a6790bef1e448680e077345c4d10dcb12";
    hash = "sha256-Sug07QTL7fxxQAf9YOprMNEQSDqeXEk7qt1g2dP0Eqk=";
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
