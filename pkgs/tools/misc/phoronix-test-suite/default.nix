{ stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "9.2.0";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "04r4zm550kp44pzl5xgj8abncrd1rxcfs7hqm38an1lz7shiisfi";
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
