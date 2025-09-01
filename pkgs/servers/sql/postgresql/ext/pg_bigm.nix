{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_bigm";
  version = "1.2-20240606";

  src = fetchFromGitHub {
    owner = "pgbigm";
    repo = "pg_bigm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Uy1DmGZR4WdtRUvNdZ5b9zBHJUb9idcEzW20rkreBs=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    # PostgreSQL 18 support issue upstream: https://github.com/pgbigm/pg_bigm/issues/28
    # Check after next package update.
    broken = lib.warnIf (
      finalAttrs.version != "1.2-20240606"
    ) "Is postgresql18Packages.pg_bigm still broken?" (lib.versionAtLeast postgresql.version "18");
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://pgbigm.osdn.jp/";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
