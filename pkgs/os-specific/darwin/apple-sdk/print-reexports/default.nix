{ lib, stdenv, libyaml }:

stdenv.mkDerivation {
  name = "print-reexports";
  src = lib.sourceFilesBySuffices ./. [".c"];

  buildInputs = [ libyaml ];

  buildPhase = ''
    $CC -lyaml -o $name main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $name $out/bin
  '';
}
