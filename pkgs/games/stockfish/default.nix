{ stdenv, fetchurl, unzip }:
stdenv.mkDerivation rec {
  version = "6";
  name = "stockfish-${version}";
  src = fetchurl {
    url = https://stockfish.s3.amazonaws.com/stockfish-6-src.zip;
    sha256 = "a69a371d3f84338cefde4575669bd930d186b046a10fa5ab0f8d1aed6cb204c3";
  };
  buildPhase = ''
  cd src
  make build ARCH=x86-64
  '';
  buildInputs = [
        stdenv
        unzip
  ];
  enableParallelBuilding = true;
  installPhase = ''
  mkdir -p $out/bin
  cp -pr stockfish $out/bin
  '';
  meta = with stdenv.lib; {
    homepage = https://stockfishchess.org/;
    description = "Strong open source chess engine";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
      '';
    maintainers = with maintainers; [ luispedro ];
    license = licenses.gpl2;
  };
}
