{
  curl,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_net";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_net";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uOy/ESRKXngAyDTLHEQ81ZxZCfdtqoP9OxsqzyQJdEY=";
  };

  buildInputs = [ curl ];

  meta = {
    description = "Async networking for Postgres";
    homepage = "https://github.com/supabase/pg_net";
    changelog = "https://github.com/supabase/pg_net/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
