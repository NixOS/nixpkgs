{ lib, stdenv, fetchFromGitHub, fetchpatch, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_bigm";
  version = "1.2-20200228";

  src = fetchFromGitHub {
    owner = "pgbigm";
    repo = "pg_bigm";
    rev = "v${version}";
    hash = "sha256-3lspEglVWzEUTiRIWqW0DpQe8gDn9R/RxsWuI9znYc8=";
  };

  patches = [
    # Fix compatiblity with PostgreSQL 16. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/pgbigm/pg_bigm/commit/2a9d783c52a1d7a2eb414da6f091f6035da76edf.patch";
      hash = "sha256-LuMpSUPnT8cPChQfA9sJEKP4aGpsbN5crfTKLnDzMN8=";
    })
  ];

  buildInputs = [ postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D -t $out/lib pg_bigm${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://pgbigm.osdn.jp/";
    maintainers = [ maintainers.marsam ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
