{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_textsearch";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "pg_textsearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TqY7mLO/aY30p1QAtILnjIvwDYEV+EYDU94TqUCucDA=";
  };

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    postgresqlExtraSettings = ''
      shared_preload_libraries='pg_textsearch'
    '';
    sql = ''
      CREATE EXTENSION IF NOT EXISTS pg_textsearch;
      CREATE TABLE documents (content text);
      INSERT INTO documents VALUES
        ('NixOS provides declarative configuration and reproducible system builds with the Nix package manager'),
        ('Nix was originally developed by Eelco Dolstra'),
        ('PostgreSQL is a powerful, open source object-relational database system');
      CREATE INDEX documents_content_bm25_idx ON documents USING bm25(content) WITH (text_config='english');
    '';

    asserts = [
      {
        query = "SELECT content FROM documents ORDER BY content <@> 'NixOS' LIMIT 1";
        expected = "'NixOS provides declarative configuration and reproducible system builds with the Nix package manager'";
        description = "BM25 index can be queried successfully.";
      }
    ];
  };

  meta = {
    description = "BM25 relevance-ranked full-text search";
    homepage = "https://github.com/timescale/pg_textsearch";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ dbe ];
    broken = lib.versionOlder postgresql.version "17";
  };
})
