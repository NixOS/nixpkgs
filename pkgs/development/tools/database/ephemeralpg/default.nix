{ stdenv, fetchurl, postgresql, getopt, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "ephemeralpg";
  version = "2.9";
  src = fetchurl {
    url = "http://ephemeralpg.org/code/${pname}-${version}.tar.gz";
    sha256 = "1ghp3kya4lxvfwz3c022cx9vqf55jbf9sjw60bxjcb5sszklyc89";
  };
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    PREFIX=$out make install
    wrapProgram $out/bin/pg_tmp --prefix PATH : ${stdenv.lib.makeBinPath [ postgresql getopt ]}
  '';
  meta = with stdenv.lib; {
    description = ''Run tests on an isolated, temporary PostgreSQL database.'';
    license = licenses.isc;
    homepage = http://ephemeralpg.org/;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
