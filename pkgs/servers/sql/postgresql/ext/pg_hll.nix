{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_hll";
  version = "2.15";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-hll";
    rev    = "refs/tags/v${version}";
    sha256 = "19d50cvp3byjyr2dc5rjmyrlp97bb19mz0ykr3w4iyc6qi5d5qj2";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "HyperLogLog for PostgreSQL";
    homepage    = "https://www.citusdata.com/";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.asl20;
  };
}
