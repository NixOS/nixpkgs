{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "plpgsql_check";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IR1x1duROt3IHYQx8CYXqUxTmFgB1sbia93k3oBfEkw=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *${postgresql.dlSuffix}
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
