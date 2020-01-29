{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_cron";
  version = "1.2.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "1hkrk6jxl20k2b0ngchblwkrzigl77jaq1gvininp4yhjdlgaks8";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = https://github.com/citusdata/pg_cron;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
