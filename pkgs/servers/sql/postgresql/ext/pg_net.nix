{ lib, stdenv, fetchFromGitHub, curl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_net";
  version = "0.7.3";

  buildInputs = [ curl postgresql ];

  src = fetchFromGitHub {
    owner  = "supabase";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    hash   = "sha256-j5qLgn/i4ljysuwgT46579N+9VpGr483vQEX/3lUYFA=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *${postgresql.dlSuffix} $out/lib
    cp sql/*.sql $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Async networking for Postgres";
    homepage    = "https://github.com/supabase/pg_net";
    changelog   = "https://github.com/supabase/pg_net/releases/tag/v${version}";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
    broken      = versionOlder postgresql.version "12";
  };
}
