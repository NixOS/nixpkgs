{ stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "8.8.1";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "1l5wnj5d652dg02j7iy7n9ab7qrpclmgvyxnh1s6cdnnnspyxznn";
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
