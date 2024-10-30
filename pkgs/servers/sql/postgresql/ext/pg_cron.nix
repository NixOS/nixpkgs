{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_cron";
  version = "1.6.4";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = pname;
    rev    = "v${version}";
    hash   = "sha256-t1DpFkPiSfdoGG2NgNT7g1lkvSooZoRoUrix6cBID40=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *${postgresql.dlSuffix} $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = "https://github.com/citusdata/pg_cron";
    changelog   = "https://github.com/citusdata/pg_cron/releases/tag/v${version}";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
