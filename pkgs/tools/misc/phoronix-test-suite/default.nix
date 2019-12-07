{ stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "9.0.1";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "056f2z1ssr2z7qnacq5aihpnawl05blbbw0bv64pkrkl0wss85x1";
  };

  buildInputs = [ php ];
  nativeBuildInputs = [ which gnused makeWrapper ];

  installPhase = ''
    ./install-sh $out
    wrapProgram $out/bin/phoronix-test-suite \
    --set PHP_BIN ${php}/bin/php \
    --prefix PATH : ${stdenv.lib.makeBinPath [ gnumake gcc ]}
  '';

  meta = with stdenv.lib; {
    description = "Open-Source, Automated Benchmarking";
    homepage = https://www.phoronix-test-suite.com/;
    maintainers = with maintainers; [ davidak ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
