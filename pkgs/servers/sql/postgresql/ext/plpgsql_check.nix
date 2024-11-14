{ lib, stdenv, fetchFromGitHub, postgresql, postgresqlTestExtension, buildPostgresqlExtension }:

buildPostgresqlExtension (finalAttrs: {
  pname = "plpgsql-check";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "plpgsql_check";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CD/G/wX6o+mC6gowlpFe1DdJWyh3cB9wxSsW2GXrENE=";
  };

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = "CREATE EXTENSION plpgsql_check;";
  };

  meta = with lib; {
    description = "Linter tool for language PL/pgSQL";
    homepage = "https://github.com/okbob/plpgsql_check";
    changelog = "https://github.com/okbob/plpgsql_check/releases/tag/v${finalAttrs.version}";
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    maintainers = [ ];
  };
})
