{ lib, stdenv, fetchFromGitHub, postgresql, curl, lz4 }:

stdenv.mkDerivation rec {
  pname = "citus";
  version = "11.0.6";

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "citus";
    rev    = "v${version}";
    sha256 = "zBygZLaFUnAkDEgrdeGwnWl1y+gIK4JWmB7gW482xx8=";
  };

  buildInputs = [ postgresql curl lz4 ];
  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out
  '';

  passthru = {
    versionCheck = postgresql.compareVersion "11" >= 0 && postgresql.compareVersion "14" < 0;
  };

  meta = with lib; {
    description = "Transparent, distributed sharding and replication for PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ ];
    platforms   = platforms.linux;
    license     = licenses.agpl3;
  };
}
