{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_auto_failover";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OIWykfFbVskrkPG/zSmZtZjc+W956KSfIzK7f5QOqpI=";
  };

  buildInputs = postgresql.buildInputs;

  meta = with lib; {
    description = "PostgreSQL extension and service for automated failover and high-availability";
    mainProgram = "pg_autoctl";
    homepage = "https://github.com/citusdata/pg_auto_failover";
    changelog = "https://github.com/citusdata/pg_auto_failover/blob/v${version}/CHANGELOG.md";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
    # PostgreSQL 17 support issue upstream: https://github.com/hapostgres/pg_auto_failover/issues/1048
    # Check after next package update.
    broken = versionAtLeast postgresql.version "17" && version == "2.1";
  };
}
