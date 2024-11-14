{ lib, stdenv, fetchFromGitHub, postgresql, buildPostgresqlExtension }:

buildPostgresqlExtension rec {
  pname = "pgvector";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    rev = "v${version}";
    hash = "sha256-r+TpFJg6WrMn0L2B7RpmSRvw3XxpHzMRtpFWDCzLvgs=";
  };

  meta = with lib; {
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/pgvector/pgvector";
    changelog = "https://github.com/pgvector/pgvector/raw/v${version}/CHANGELOG.md";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ ];
  };
}
