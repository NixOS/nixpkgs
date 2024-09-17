{ lib, stdenv, fetchFromGitHub, postgresql, buildPostgresExtension }:

buildPostgresExtension rec {
  pname = "pg_topn";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-topn";
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-kq3P+a9NWLKN/CsISGHfInbeL4ex4KIeDhTKyyN7FVE=";
  };

  meta = with lib; {
    description = "Efficient querying of 'top values' for PostgreSQL";
    homepage    = "https://github.com/citusdata/postgresql-topn";
    changelog   = "https://github.com/citusdata/postgresql-topn/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.agpl3Only;
  };
}
