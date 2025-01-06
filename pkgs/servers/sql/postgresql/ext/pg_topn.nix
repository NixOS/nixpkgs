{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_topn";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "postgresql-topn";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-lP6Iil/BUv4ga+co+oBpKv1FBqFuBGfNjueEolM6png=";
  };

  meta = with lib; {
    description = "Efficient querying of 'top values' for PostgreSQL";
    homepage = "https://github.com/citusdata/postgresql-topn";
    changelog = "https://github.com/citusdata/postgresql-topn/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = licenses.agpl3Only;
  };
}
