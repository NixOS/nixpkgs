{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_embedding";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "neondatabase";
    repo = pname;
    rev = version;
    hash = "sha256-dpwBwomUPzxnBVnnK4IWYlP+c8Z/EKerXhgrLcQj8Gk=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "PostgreSQL extension implementing the HNSW algorithm for vector similarity search";
    homepage = "https://github.com/neondatabase/pg_embedding";
    maintainers = with maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
    broken = versionOlder postgresql.version "14";
  };
}
