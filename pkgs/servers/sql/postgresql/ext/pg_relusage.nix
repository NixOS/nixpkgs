{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_relusage";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "adept";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "8hJNjQ9MaBk3J9a73l+yQMwMW/F2N8vr5PO2o+5GvYs=";
  };

  meta = with lib; {
    description = "pg_relusage extension for PostgreSQL: discover and log the relations used in your statements";
    homepage = "https://github.com/adept/pg_relusage";
    maintainers = with maintainers; [ thenonameguy ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
