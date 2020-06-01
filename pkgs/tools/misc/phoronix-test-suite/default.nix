{ stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc, callPackage }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "9.6.0";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "1wgw5lwpm3ylby2llnjiq356cdb3v1jghj7xq659c722wj617i88";
  };

  buildInputs = [ php ];
  nativeBuildInputs = [ which gnused makeWrapper ];

  installPhase = ''
    ./install-sh $out
    wrapProgram $out/bin/phoronix-test-suite \
    --set PHP_BIN ${php}/bin/php \
    --prefix PATH : ${stdenv.lib.makeBinPath [ gnumake gcc ]}
  '';

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

  meta = with stdenv.lib; {
    description = "Open-Source, Automated Benchmarking";
    homepage = "https://www.phoronix-test-suite.com/";
    maintainers = with maintainers; [ davidak ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
