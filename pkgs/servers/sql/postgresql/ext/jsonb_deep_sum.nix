{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension {
  pname = "jsonb_deep_sum";
  version = "0-unstable-2021-12-24";

  src = fetchFromGitHub {
    owner = "furstenheim";
    repo = "jsonb_deep_sum";
    rev = "d9c69aa6b7da860e5522a9426467e67cb787980c";
    hash = "sha256-W1wNILAwTAjFPezq+grdRMA59KEnMZDz69n9xQUqdc0=";
  };

  meta = {
    description = "PostgreSQL extension to easily add jsonb numeric";
    homepage = "https://github.com/furstenheim/jsonb_deep_sum";
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
}
