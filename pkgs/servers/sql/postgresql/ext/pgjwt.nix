{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation {
  pname = "pgjwt";
  version = "unstable-2021-11-13";

  src = fetchFromGitHub {
    owner  = "michelp";
    repo   = "pgjwt";
    rev    = "9742dab1b2f297ad3811120db7b21451bca2d3c9";
    sha256 = "sha256-Hw3R9bMGDmh+dMzjmqZSy/rT4mX8cPU969OJiARFg10=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/postgresql/extension
    cp pg*sql *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "PostgreSQL implementation of JSON Web Tokens";
    longDescription = ''
      sign() and verify() functions to create and verify JSON Web Tokens.
    '';
    license = licenses.mit;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [spinus];
  };
}
