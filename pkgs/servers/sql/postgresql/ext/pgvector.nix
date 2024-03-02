{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgvector";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    rev = "v${version}";
    hash = "sha256-hXm+k0BZ9xZP1Tnek14jPoKCPQkA5ovscu9IX2mW7Kc=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib vector${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension sql/vector-*.sql
    install -D -t $out/share/postgresql/extension vector.control
  '';

  meta = with lib; {
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/pgvector/pgvector";
    changelog = "https://github.com/pgvector/pgvector/raw/v${version}/CHANGELOG.md";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
