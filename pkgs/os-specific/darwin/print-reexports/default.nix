{ lib, stdenv, libyaml }:

stdenv.mkDerivation {
  name = "print-reexports";
  src = lib.sourceFilesBySuffices ./. [".c"];

  buildInputs = [ libyaml ];

  buildPhase = ''
    $CC -lyaml -o print-reexports main.c
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv print-reexports $out/bin

    runHook postInstall
  '';
  meta.mainProgram = "print-reexports";
}
