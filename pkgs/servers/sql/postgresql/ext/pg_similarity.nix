{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_similarity";
  version = "pg_similarity_1_0-unstable-2026-11-22";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "pg_similarity";
    rev = "3a3ac5f5aaadce22d0dc303475f73ba90dfcd7a6";
    hash = "sha256-DdkbKQco4xWhIfNAZ2L3LiV/Qu+yNS+CsyNlRFTOD84=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = "CREATE EXTENSION pg_similarity;";
    asserts = [
      {
        query = "lev('nixpkgs', 'nixpkgs')";
        expected = "1";
        description = "lev() returns 1 for identical strings";
      }
      {
        query = "hamming_text('abc', 'abd') < 1";
        expected = "true";
        description = "hamming_text() returns less than 1 for different strings";
      }
      {
        query = "'nixpkgs'::text ~== 'nixpkgs'::text";
        expected = "true";
        description = "~== operator matches identical strings";
      }
      {
        query = "jaccard('', '')";
        expected = "1";
        description = "jaccard() returns 1 instead of NaN when neither side has tokens";
      }
    ];
  };

  meta = {
    description = "Extension to support similarity queries on PostgreSQL";
    longDescription = ''
      pg_similarity is an extension to support similarity queries on PostgreSQL. The implementation
      is tightly integrated in the RDBMS in the sense that it defines operators so instead of the traditional
      operators (= and <>) you can use ~~~ and ~!~ (any of these operators represents a similarity function).
    '';
    homepage = "https://github.com/eulerto/pg_similarity";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
