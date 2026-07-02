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
    # PostgreSQL 18 support issue upstream: https://github.com/pgspider/sqlite_fdw/issues/117
    # Note: already fixed on `master` branch.
    # Check after next package update.
    broken = lib.warnIf (
      finalAttrs.version != "2.5.0"
    ) "Is postgresql18Packages.sqlite_fdw still broken?" (lib.versionAtLeast postgresql.version "18");
    description = "SQLite Foreign Data Wrapper for PostgreSQL";
    homepage = "https://github.com/pgspider/sqlite_fdw";
    changelog = "https://github.com/pgspider/sqlite_fdw/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
    platforms = lib.platforms.unix;
    license = lib.licenses.postgresql;
  };
})
