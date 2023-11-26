{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_topn";
  version = "2.6.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-topn";
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-kq3P+a9NWLKN/CsISGHfInbeL4ex4KIeDhTKyyN7FVE=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *${postgresql.dlSuffix} $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Efficient querying of 'top values' for PostgreSQL";
    homepage    = "https://github.com/citusdata/postgresql-topn";
    changelog   = "https://github.com/citusdata/postgresql-topn/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.agpl3Only;
  };
}
