{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_cron";
  version = "1.3.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "1hvd0nfaq5q9yfxfcb0fbrjbdal06adjplvmaag88a0msdlirl7z";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = "https://github.com/citusdata/pg_cron";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
