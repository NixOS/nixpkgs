{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2024-03-09";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "5e51b23b1f25eef426da5548964e14fef4b4a485";
    hash = "sha256-sAqTGy7pXDCgJ9UImJPYwUfbYgRjNjZdHHSyH/+QRNs=";
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
