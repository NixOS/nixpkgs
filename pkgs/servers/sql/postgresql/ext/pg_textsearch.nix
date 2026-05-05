{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_textsearch";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "pg_textsearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zZctWEJVItzJBke46J4CgvOAGDLmOZbCeUThkrnaPug";
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
        query = "SELECT count(*) FROM documents ORDER BY content <@> 'nix' LIMIT 10";
        expected = "2";
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
