{ lib, stdenv, fetchFromGitHub, postgresql, buildPostgresExtension }:

buildPostgresExtension rec {
  pname = "rum";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "postgrespro";
    repo = "rum";
    rev = version;
    hash = "sha256-yy2xeDnk3fENN+En0st4mv60nZlqPafIzwf68jwJ5fE=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = with lib; {
    description = "Full text search index method for PostgreSQL";
    homepage = "https://github.com/postgrespro/rum";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
