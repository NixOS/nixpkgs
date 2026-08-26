{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension {
  pname = "jsonb_deep_sum";
  version = "0-unstable-2026-06-17";

  src = fetchFromGitHub {
    owner = "furstenheim";
    repo = "jsonb_deep_sum";
    rev = "3f1b4be67e3bc74b7cc4635fc285dc3c602ee420";
    hash = "sha256-44GApqemY9sLukViGbyTzlI7qHeAGNdMCKZOawPUj8s=";
  };

  meta = {
    description = "PostgreSQL extension to easily add jsonb numeric";
    homepage = "https://github.com/furstenheim/jsonb_deep_sum";
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
}
