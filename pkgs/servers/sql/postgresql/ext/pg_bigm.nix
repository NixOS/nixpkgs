{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_bigm";
  version = "1.2-20250903";

  src = fetchFromGitHub {
    owner = "pgbigm";
    repo = "pg_bigm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8V+sGebagYxXW1o2k2cNlGG4cFOObdRAvqCXKyR95hI=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://pgbigm.osdn.jp/";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
