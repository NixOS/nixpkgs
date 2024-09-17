{ lib, stdenv, fetchFromGitHub, postgresql, freetds, unstableGitUpdater, buildPostgresExtension }:

buildPostgresExtension rec {
  pname = "tds_fdw";
  # Move to stable version when it's released.
  version = "2.0.3-unstable-2024-02-10";

  buildInputs = [ freetds ];

  src = fetchFromGitHub {
    owner  = "tds-fdw";
    repo   = "tds_fdw";
    rev    = "f78bd38955d01d3ca357b90717588ec2f90b4991";
    hash   = "sha256-3J8wzk0YIxRPhALd5PgVW000hzQw3r4rTrnqg9uB/Bo=";
  };

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    description = "PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage    = "https://github.com/tds-fdw/tds_fdw";
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
