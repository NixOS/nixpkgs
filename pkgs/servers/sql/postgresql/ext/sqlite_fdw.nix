{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  sqlite,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "sqlite_fdw";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "pgspider";
    repo = "sqlite_fdw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zPVIFzUv6UFFHq0Zi5MeQOcvgsfZAKGkkNIGxkTJ+oo=";
  };

  buildInputs = [ sqlite ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "SQLite Foreign Data Wrapper for PostgreSQL";
    homepage = "https://github.com/pgspider/sqlite_fdw";
    changelog = "https://github.com/pgspider/sqlite_fdw/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
    platforms = lib.platforms.unix;
    license = lib.licenses.postgresql;
  };
})
