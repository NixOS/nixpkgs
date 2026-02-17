{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "plpgsql-check";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "plpgsql_check";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SqL+Rw1ICeTj2b5bfW+awOf0Kk4SrsvfC6HF6XNe6+I=";
  };

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = "CREATE EXTENSION plpgsql_check;";
  };

  meta = {
    description = "Linter tool for language PL/pgSQL";
    homepage = "https://github.com/okbob/plpgsql_check";
    changelog = "https://github.com/okbob/plpgsql_check/releases/tag/v${finalAttrs.version}";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
    maintainers = [ ];
    broken = lib.versionOlder postgresql.version "14";
  };
})
