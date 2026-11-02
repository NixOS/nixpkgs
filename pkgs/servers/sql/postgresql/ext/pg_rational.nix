{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_rational";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "begriffs";
    repo = "pg_rational";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8ctA1XkBOMyO0V9sy2ll6q89jLa7aG5xW9rtr3ugoeA=";
  };

  meta = {
    description = "Precise fractional arithmetic for PostgreSQL";
    homepage = "https://github.com/begriffs/pg_rational";
    maintainers = with lib.maintainers; [ netcrns ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
