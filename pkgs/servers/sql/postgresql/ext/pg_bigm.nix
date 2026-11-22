{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_bigm";
  version = "1.2-20261118";

  src = fetchFromGitHub {
    owner = "pgbigm";
    repo = "pg_bigm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6A3H904GKQJ0MEp4Fa0lJUqPVlEePYgka3cCY2cf4NA=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://github.com/pgbigm/pg_bigm";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
