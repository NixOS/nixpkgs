{ lib, stdenv, fetchFromGitHub, postgresql, buildPostgresqlExtension }:

buildPostgresqlExtension rec {
  pname = "pg_partman";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner  = "pgpartman";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-GrVOJ5ywZMyqyDroYDLdKkXDdIJSDGhDfveO/ZvrmYs=";
  };

  meta = with lib; {
    description = "Partition management extension for PostgreSQL";
    homepage    = "https://github.com/pgpartman/pg_partman";
    changelog   = "https://github.com/pgpartman/pg_partman/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
    broken      = versionOlder postgresql.version "14";
  };
}
