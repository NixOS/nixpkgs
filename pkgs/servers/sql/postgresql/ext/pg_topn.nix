{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_topn";
  version = "2.3.1";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-topn";
    rev    = "refs/tags/v${version}";
    sha256 = "0ai07an90ywhk10q52hajgb33va5q76j7h8vj1r0rvq6dyii0wal";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Efficient querying of 'top values' for PostgreSQL";
    homepage    = "https://github.com/citusdata/postgresql-topn";
    changelog   = "https://github.com/citusdata/postgresql-topn/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.agpl3;
  };
}
