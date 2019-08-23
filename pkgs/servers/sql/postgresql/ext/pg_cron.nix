{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_cron";
  version = "1.1.4";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0wkqgrm3v999hjcc82h24jv1pib6f6bw8jsv83hgk6g3iv6xsjg9";
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
