{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_cron";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t1DpFkPiSfdoGG2NgNT7g1lkvSooZoRoUrix6cBID40=";
  };

  meta = with lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage = "https://github.com/citusdata/pg_cron";
    changelog = "https://github.com/citusdata/pg_cron/releases/tag/v${version}";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
