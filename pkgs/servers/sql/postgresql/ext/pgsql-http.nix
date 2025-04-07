{
  curl,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension rec {
  pname = "pgsql-http";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "pramsey";
    repo = "pgsql-http";
    tag = "v${version}";
    hash = "sha256-Ij8BaNj2SOwDfjgLxrpLFvvPCzSahXyyckRPGmcqKtE=";
  };

  buildInputs = [ curl ];
  nativeBuildInputs = [ curl ];

  meta = {
    description = "HTTP client for PostgreSQL, retrieve a web page from inside the database";
    homepage = "https://github.com/pramsey/pgsql-http";
    changelog = "https://github.com/pramsey/pgsql-http/releases/tag/v${version}";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
}
