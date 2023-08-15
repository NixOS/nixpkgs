{ lib, stdenv, fetchFromGitHub, curl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_net";
  version = "0.7.2";

  buildInputs = [ curl postgresql ];

  src = fetchFromGitHub {
    owner  = "supabase";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    hash   = "sha256-9Ki3fyinHTYrfckxAY0fCTlzJd9l+n7QRUV7mIWrqmc=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp sql/*.sql $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Async networking for Postgres";
    homepage    = "https://github.com/supabase/pg_net";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
