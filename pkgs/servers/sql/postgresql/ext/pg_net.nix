{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_net";
  version = "0.13.0";

  buildInputs = [ curl ];

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FRaTZPCJQPYAFmsJg22hYJJ0+gH1tMdDQoCQgiqEnaA=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with lib; {
    description = "Async networking for Postgres";
    homepage = "https://github.com/supabase/pg_net";
    changelog = "https://github.com/supabase/pg_net/releases/tag/v${version}";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
