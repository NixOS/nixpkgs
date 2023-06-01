{ lib, stdenv, fetchFromGitHub, postgresql, curl, lz4 }:

stdenv.mkDerivation rec {
  pname = "citus";
  version = "11.3.0";

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "citus";
    rev    = "v${version}";
    sha256 = "e+pkKFFFIATIoODRmOGFr0yFCYo2Q7mVJJ/zbtObJ30=";
  };

  buildInputs = [ postgresql curl lz4 ];
  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out
  '';

  installPhase = ''
    runHook preInstall
  '';

  passthru = {
    versionCheck = postgresql.compareVersion "11" >= 0;
  };

  meta = with lib; {
    description = "Transparent, distributed sharding and replication for PostgreSQL";
    homepage    = "https://www.citusdata.com/";
    maintainers = with maintainers; [ hariamoor ];
    platforms   = platforms.linux;
    license     = licenses.agpl3;
  };
}
