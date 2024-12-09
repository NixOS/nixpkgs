{
  lib,
  fetchFromGitHub,
  sqlite,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "sqlite_fdw";
  # TODO: Check whether PostgreSQL 17 is still broken after next update.
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "pgspider";
    repo = "sqlite_fdw";
    rev = "v${version}";
    hash = "sha256-u51rcKUH2nZyZbI2g3crzHt5jiacbTq4xmfP3JgqnnM=";
  };

  buildInputs = [ sqlite ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "SQLite Foreign Data Wrapper for PostgreSQL";
    homepage = "https://github.com/pgspider/sqlite_fdw";
    changelog = "https://github.com/pgspider/sqlite_fdw/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
    platforms = lib.platforms.unix;
    license = lib.licenses.postgresql;
    broken = lib.versionAtLeast postgresql.version "17";
  };
}
