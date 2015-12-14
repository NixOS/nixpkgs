{ stdenv, pkgconfig, pkgs, fetchurl }:
pkgs.stdenv.mkDerivation {
  version = "6";
  name = "stockfish";
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
        pkgs.unzip
  ];
  enableParallelBuilding = true;
  installPhase = ''
  mkdir -p $out/bin
  cp -pr stockfish $out/bin
  '';
}
