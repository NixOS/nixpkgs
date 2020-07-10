{ stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc, callPackage }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "9.6.1";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "1qnci0bipzq68mwfgmm7kcxjxcpfdrqf705am2jsj1mfd82y7yla";
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
