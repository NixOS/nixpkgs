{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  curl,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_tracing";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "pg_tracing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5W1lOpY0RrBsYQPUSD8xKCedLktI+GGkn0xGlqJ0N6c=";
  };

  buildInputs = [ curl ];

  meta = {
    description = "PostgreSQL extension that generates server-side spans for distributed tracing";
    homepage = "https://github.com/DataDog/pg_tracing";
    changelog = "https://github.com/DataDog/pg_tracing/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ mkleczek ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
