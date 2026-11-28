{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "rum";
  version = "1.3.15-unstable-2026-11-18";

  src = fetchFromGitHub {
    owner = "postgrespro";
    repo = "rum";
    rev = "c341a57a188fc2d6a6c44c55fc03fd0f3e43373b";
    hash = "sha256-8vmhjKn7rIz6Uvo3vFPGZop6gV/2+LxFMyYhuVtER4Q=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = ''
      CREATE EXTENSION rum;
      CREATE TABLE test_table (t text, v tsvector);
      CREATE INDEX test_table_rumindex ON test_table USING rum (v rum_tsvector_ops);
    '';
  };

  meta = {
    description = "Full text search index method for PostgreSQL";
    homepage = "https://github.com/postgrespro/rum";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ DeeUnderscore ];
  };
})
