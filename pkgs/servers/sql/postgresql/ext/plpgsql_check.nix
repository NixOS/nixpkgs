{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "plpgsql_check";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-flRkPyHLc/cf+JQK04/Vl0I6ILx1GxWYMy9FnT9M//Q=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Linter tool for language PL/pgSQL";
    homepage = "https://github.com/okbob/plpgsql_check";
    changelog = "https://github.com/okbob/plpgsql_check/releases/tag/v${version}";
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    broken = versionOlder postgresql.version "12";
    maintainers = [ maintainers.marsam ];
  };
}
