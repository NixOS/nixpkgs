{ lib, stdenv, fetchFromGitHub, curl, postgresql, buildPostgresqlExtension }:

buildPostgresqlExtension rec {
  pname = "pg_net";
  version = "0.8.0";

  buildInputs = [ curl ];

  src = fetchFromGitHub {
    owner  = "supabase";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    hash   = "sha256-ZPsRPWV1G3lMM2mT+H139Wvgoy8QnmeUbzEnGeDJmZA=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with lib; {
    description = "Async networking for Postgres";
    homepage    = "https://github.com/supabase/pg_net";
    changelog   = "https://github.com/supabase/pg_net/releases/tag/v${version}";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
