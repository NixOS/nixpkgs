{ stdenv, fetchurl, postgresql, getopt, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "ephemeralpg";
  version = "3.1";
  src = fetchurl {
    url = "http://ephemeralpg.org/code/${pname}-${version}.tar.gz";
    sha256 = "1ap22ki8yz6agd0qybcjgs4b9izw1rwwcgpxn3jah2ccfyax34s6";
  };
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    PREFIX=$out make install
    wrapProgram $out/bin/pg_tmp --prefix PATH : ${stdenv.lib.makeBinPath [ postgresql getopt ]}
  '';
  meta = with stdenv.lib; {
    description = "Run tests on an isolated, temporary PostgreSQL database";
    license = licenses.isc;
    homepage = "http://ephemeralpg.org/";
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
