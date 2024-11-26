{ lib, stdenv, libyaml }:

stdenv.mkDerivation {
  name = "print-reexports";
  src = lib.sourceFilesBySuffices ./. [".c"];

  buildInputs = [ libyaml ];

  buildPhase = ''
    $CC -lyaml -o print-reexports main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv print-reexports $out/bin
  '';
  meta.mainProgram = "print-reexports";
}
