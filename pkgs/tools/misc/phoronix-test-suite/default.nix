{ stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc, callPackage }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "10.0.1";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "09wrrcxfvh7pwv0jqpyzjsr0rd7askfr0s2xr1wv9v40znxmsmzz";
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
