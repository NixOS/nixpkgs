{
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Fix build with PostgreSQL 19, drop at the next release after v1.2-20250903
    (fetchpatch2 {
      url = "https://github.com/pgbigm/pg_bigm/commit/4f103a867ace5962a355f23eb156d92159442884.patch";
      hash = "sha256-LVuV6Gq8jfokvZG16w5lvfLKbWqqWlAt9LkaqMlnoLA=";
    })
  ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://github.com/pgbigm/pg_bigm";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
