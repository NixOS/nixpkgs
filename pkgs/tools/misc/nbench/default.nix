{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nbench-byte";
  version = "2.2.3";

  src = fetchurl {
    url = "http://www.math.utah.edu/~mayer/linux/nbench-byte-${version}.tar.gz";
    sha256 = "1b01j7nmm3wd92ngvsmn2sbw43sl9fpx4xxmkrink68fz1rx0gbj";
  };

  prePatch = ''
    substituteInPlace nbench1.h --replace '"NNET.DAT"' "\"$out/NNET.DAT\""
    substituteInPlace sysspec.h --replace "malloc.h" "stdlib.h"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile --replace "-static" ""
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isGnu [
    stdenv.cc.libc.static
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p $out/bin
    cp nbench $out/bin
    cp NNET.DAT $out
  '';

  meta = with lib; {
    homepage = "https://www.math.utah.edu/~mayer/linux/bmark.html";
    description = "Synthetic computing benchmark program";
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ bennofs ];
    mainProgram = "nbench";
  };
}
