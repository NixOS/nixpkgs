{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_embedding";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "neondatabase";
    repo = pname;
    rev = version;
    hash = "sha256-NTBxsQB8mR7e/CWwkCEyDiYhi3Nxl/aKgRBwqc0THcI=";
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
    license = licenses.asl20;
    broken = versionOlder postgresql.version "12";
  };
}
