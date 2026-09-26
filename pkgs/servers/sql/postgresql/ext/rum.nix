{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "rum";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "postgrespro";
    repo = "rum";
    tag = finalAttrs.version;
    hash = "sha256-iOx7u0JURBUUFerRlg3DuidFeBmGFOXz8mu20mQeopo=";
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
