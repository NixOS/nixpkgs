{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "pgjwt";
  version = "0-unstable-2023-03-02";

  src = fetchFromGitHub {
    owner = "michelp";
    repo = "pgjwt";
    rev = "f3d82fd30151e754e19ce5d6a06c71c20689ce3d";
    sha256 = "sha256-nDZEDf5+sFc1HDcG2eBNQj+kGcdAYRXJseKi9oww+JU=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/postgresql/extension
    cp pg*sql *.control $out/share/postgresql/extension
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "PostgreSQL implementation of JSON Web Tokens";
    longDescription = ''
      sign() and verify() functions to create and verify JSON Web Tokens.
    '';
    license = licenses.mit;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ spinus ];
  };
}
