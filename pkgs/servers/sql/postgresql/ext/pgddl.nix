{
  fetchFromGitHub,
  lib,
  perl,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "pgddl";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "lacanoid";
    repo = "pgddl";
    tag = finalAttrs.version;
    hash = "sha256-8EP3I4DmfzW5B+w/c3V6jvaVWtgZcNjL24sKVlme5hU=";
  };

  nativeBuildInputs = [
    perl
  ];

  preBuild = ''
    patchShebangs --build ./bin/ ./docs
  '';

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = ''
      CREATE EXTENSION ddlx;

      CREATE TABLE a(i int PRIMARY KEY, j int);

      SELECT ddlx_create('a'::regclass);
      SELECT ddlx_drop('a'::regclass);
      SELECT ddlx_script('a'::regclass);
    '';
  };

  meta = {
    description = "DDL eXtractor functions for PostgreSQL";
    homepage = "https://github.com/lacanoid/pgddl";
    changelog = "https://github.com/lacanoid/pgddl/releases/tag/${finalAttrs.version}";
    platforms = postgresql.meta.platforms;
    maintainers = [ lib.maintainers.joshainglis ];
    license = lib.licenses.postgresql;
  };
})
