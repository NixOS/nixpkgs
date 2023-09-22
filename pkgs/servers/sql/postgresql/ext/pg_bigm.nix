{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_bigm";
  version = "1.2-20200228";

  src = fetchFromGitHub {
    owner = "pgbigm";
    repo = "pg_bigm";
    rev = "v${version}";
    hash = "sha256-3lspEglVWzEUTiRIWqW0DpQe8gDn9R/RxsWuI9znYc8=";
  };

  buildInputs = [ postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    mkdir -p $out/bin    # For buildEnv to setup proper symlinks. See #22653
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://pgbigm.osdn.jp/";
    maintainers = [ maintainers.marsam ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
