{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "temporal_tables";
  version = "1.2.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "mlt";
    repo   = pname;
    rev    = "6cc86eb03d618d6b9fc09ae523f1a1e5228d22b5";
    sha256 = "0ykv37rm511n5955mbh9dcp7pgg88z1nwgszav7z6pziaj3nba8x";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Temporal Tables PostgreSQL Extension ";
    homepage    = "https://github.com/mlt/temporal_tables";
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.bsd2;
  };
}
