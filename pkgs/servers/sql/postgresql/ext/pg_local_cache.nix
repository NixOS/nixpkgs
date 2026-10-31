{
  fetchFromGitHub,
  lib,
  openssl,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_local_cache";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "profundium";
    repo = "pg_local_cache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TZP9BtDUDMCQEUuttBu7PzgPL8rxc3hJQ+KfFwdM0yk=";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "Transaction-aware PostgreSQL primary-key row cache served over RESP";
    homepage = "https://github.com/profundium/pg_local_cache";
    changelog = "https://github.com/profundium/pg_local_cache/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ maxbronnikov10 ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
