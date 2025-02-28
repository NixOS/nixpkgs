{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "jsonb_deep_sum";
  version = "0-unstable-2021-12-24";

  src = fetchFromGitHub {
    owner = "furstenheim";
    repo = "jsonb_deep_sum";
    rev = "d9c69aa6b7da860e5522a9426467e67cb787980c";
    sha256 = "sha256-W1wNILAwTAjFPezq+grdRMA59KEnMZDz69n9xQUqdc0=";
  };

  meta = with lib; {
    description = "PostgreSQL extension to easily add jsonb numeric";
    homepage = "https://github.com/furstenheim/jsonb_deep_sum";
    maintainers = with maintainers; [ _1000101 ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
  };
}
