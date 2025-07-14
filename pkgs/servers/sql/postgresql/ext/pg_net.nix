{
  curl,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_net";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_net";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MXZewz6vb1ZEGMzbk/x0VtBDH2GxnwYWsy3EjJnas2U=";
  };

  buildInputs = [ curl ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional (lib.versionAtLeast postgresql.version "18") "-Wno-error=missing-variable-declarations"
  );

  meta = {
    description = "Async networking for Postgres";
    homepage = "https://github.com/supabase/pg_net";
    changelog = "https://github.com/supabase/pg_net/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
