{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_textsearch";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "pg_textsearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aFuaz/gd72rdMdQKI12ENF+CrKPaiqxysHUYidkLsHc=";
  };

  meta = {
    description = "BM25 relevance-ranked full-text search";
    homepage = "https://github.com/timescale/pg_textsearch";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ dbe ];
    broken = lib.versionOlder postgresql.version "17";
  };
})
