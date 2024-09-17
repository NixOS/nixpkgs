{ lib, stdenv, fetchFromGitHub, postgresql, buildPostgresExtension }:

buildPostgresExtension rec {
  pname = "pg_cron";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = pname;
    rev    = "v${version}";
    hash   = "sha256-/dD1gX0+RRsBFIjSV9TVk+ppPw0Jrzssl+rRZ2qAp4w=";
  };

  meta = with lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = "https://github.com/citusdata/pg_cron";
    changelog   = "https://github.com/citusdata/pg_cron/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
