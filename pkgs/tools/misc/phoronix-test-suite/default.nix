{ lib, stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc, callPackage }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "10.2.1";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-2HB4TPbyG+cTY6O1k0tRPrnKyg41SYnVM919Hii3gpg=";
  };

  buildInputs = [ php ];
  nativeBuildInputs = [ which gnused makeWrapper ];

  installPhase = ''
    ./install-sh $out
    wrapProgram $out/bin/phoronix-test-suite \
    --set PHP_BIN ${php}/bin/php \
    --prefix PATH : ${lib.makeBinPath [ gnumake gcc ]}
  '';

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Open-Source, Automated Benchmarking";
    homepage = "https://www.phoronix-test-suite.com/";
    maintainers = with maintainers; [ davidak ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
