{
  lib,
  stdenv,
  fetchurl,
  postgresql,
  getopt,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "ephemeralpg";
  version = "3.3";
  src = fetchurl {
    url = "https://eradman.com/ephemeralpg/code/${pname}-${version}.tar.gz";
    hash = "sha256-pVQrfSpwJnxCRXAUpZQZsb0Z/wlLbjdaYmhVevgHrgo=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    PREFIX=$out make install
    wrapProgram $out/bin/pg_tmp --prefix PATH : ${
      lib.makeBinPath [
        postgresql
        getopt
      ]
    }
  '';
  meta = with lib; {
    description = "Run tests on an isolated, temporary PostgreSQL database";
    license = licenses.isc;
    homepage = "https://eradman.com/ephemeralpg/";
    platforms = platforms.all;
    maintainers = with maintainers; [
      hrdinka
      medv
    ];
  };
}
