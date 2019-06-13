{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_hll-${version}";
  version = "2.12";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-hll";
    rev    = "refs/tags/v${version}";
    sha256 = "1jdc9gjqc3dkjxv855q1p594j0awhrrymrcqnl5vw5vx2ny3bpgn";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/extension
    cp *.control $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "HyperLogLog for PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.asl20;
  };
}
