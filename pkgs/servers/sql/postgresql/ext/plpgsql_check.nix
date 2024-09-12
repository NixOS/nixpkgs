{ lib, stdenv, fetchFromGitHub, postgresql, postgresqlTestHook }:

stdenv.mkDerivation rec {
  pname = "plpgsql-check";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "plpgsql_check";
    rev = "v${version}";
    hash = "sha256-CD/G/wX6o+mC6gowlpFe1DdJWyh3cB9wxSsW2GXrENE=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  passthru.tests.extension = stdenv.mkDerivation {
    name = "plpgsql-check-test";
    dontUnpack = true;
    doCheck = true;
    buildInputs = [ postgresqlTestHook ];
    nativeCheckInputs = [ (postgresql.withPackages (ps: [ ps.plpgsql_check ])) ];
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    failureHook = "postgresqlStop";
    checkPhase = ''
      runHook preCheck
      psql -a -v ON_ERROR_STOP=1 -c "CREATE EXTENSION plpgsql_check;"
      runHook postCheck
    '';
    installPhase = "touch $out";
  };

  meta = with lib; {
    description = "Linter tool for language PL/pgSQL";
    homepage = "https://github.com/okbob/plpgsql_check";
    changelog = "https://github.com/okbob/plpgsql_check/releases/tag/v${version}";
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    maintainers = [ ];
  };
}
