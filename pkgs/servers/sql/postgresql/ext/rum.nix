{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "rum";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "postgrespro";
    repo = "rum";
    tag = finalAttrs.version;
    hash = "sha256-VsfpxQqRBu9bIAP+TfMRXd+B3hSjuhU2NsutocNiCt8=";
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
    # PostgreSQL 18 support issue upstream: https://github.com/postgrespro/rum/issues/156
    # Check after next package update.
    broken = lib.warnIf (finalAttrs.version != "1.3.14") "Is postgresql18Packages.rum still broken?" (
      lib.versionAtLeast postgresql.version "18"
    );
    description = "Full text search index method for PostgreSQL";
    homepage = "https://github.com/postgrespro/rum";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ DeeUnderscore ];
  };
})
