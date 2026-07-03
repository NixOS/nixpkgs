{
  curl,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgsql-http";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "pramsey";
    repo = "pgsql-http";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vTOLAv0TYks8ubQa/y7+XjaIZuHEfh2wi2I38UNJ7NM=";
  };

  buildInputs = [ curl ];
  nativeBuildInputs = [ curl ];

  meta = {
    description = "HTTP client for PostgreSQL, retrieve a web page from inside the database";
    homepage = "https://github.com/pramsey/pgsql-http";
    changelog = "https://github.com/pramsey/pgsql-http/releases/tag/v${finalAttrs.version}";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
