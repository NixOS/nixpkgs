{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension rec {
  pname = "pg_bigm";
  version = "1.2-20240606";

  src = fetchFromGitHub {
    owner = "pgbigm";
    repo = "pg_bigm";
    tag = "v${version}";
    hash = "sha256-5Uy1DmGZR4WdtRUvNdZ5b9zBHJUb9idcEzW20rkreBs=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://pgbigm.osdn.jp/";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
}
