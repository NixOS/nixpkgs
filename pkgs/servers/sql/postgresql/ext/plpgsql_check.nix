{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "plpgsql-check";
  version = "2.7.15";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "plpgsql_check";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JF0aTYakoHMRdiWcA70mYFvzTiwMhOJZfqRj+6JC6n0=";
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
  };
})
