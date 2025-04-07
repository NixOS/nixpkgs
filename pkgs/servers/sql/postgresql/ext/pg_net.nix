{
  curl,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension rec {
  pname = "pg_net";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_net";
    tag = "v${version}";
    hash = "sha256-c1pxhTyrE5j6dY+M5eKAboQNofIORS+Dccz+7HKEKQI=";
  };

  buildInputs = [ curl ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "Async networking for Postgres";
    homepage = "https://github.com/supabase/pg_net";
    changelog = "https://github.com/supabase/pg_net/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
}
