{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension {
  pname = "pg_similarity";
  version = "pg_similarity_1_0-unstable-2021-01-12";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "pg_similarity";
    rev = "b9cb0a2d501b91e33cd1ef550b05483ca3563f71";
    sha256 = "sha256-L04ANvyfzHgW7fINeJEY6T77Vojq3SI8P1TWiCRSPs0=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/eulerto/pg_similarity/pull/43
      # Also applied in debian as https://sources.debian.org/data/main/p/pg-similarity/1.0-8/debian/patches/pg16
      name = "pg16.patch";
      url = "https://github.com/eulerto/pg_similarity/commit/f7781ea5ace80f697a8249e03e3ce47d4b0f6b2f.patch";
      hash = "sha256-MPDvWfNzSg28lXL5u5/Un9pOCJjqJ4Fz9b8XCfalgts=";
    })
  ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "Extension to support similarity queries on PostgreSQL";
    longDescription = ''
      pg_similarity is an extension to support similarity queries on PostgreSQL. The implementation
      is tightly integrated in the RDBMS in the sense that it defines operators so instead of the traditional
      operators (= and <>) you can use ~~~ and ~!~ (any of these operators represents a similarity function).
    '';
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ danbst ];
  };
}
