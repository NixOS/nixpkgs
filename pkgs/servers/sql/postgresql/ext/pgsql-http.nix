{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pgsql-http";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "pramsey";
    repo = "pgsql-http";
    rev = "v${version}";
    hash = "sha256-I9NDCXA6jColx/iFsvc3ujVbh3tjpqTgoW9VIzD2OTk=";
  };

  buildInputs = [ curl ];

  meta = with lib; {
    description = "HTTP client for PostgreSQL, retrieve a web page from inside the database";
    homepage = "https://github.com/pramsey/pgsql-http";
    changelog = "https://github.com/pramsey/pgsql-http/releases/tag/v${version}";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
  };
}
