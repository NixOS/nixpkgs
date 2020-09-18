{ stdenv, libyaml }:

stdenv.mkDerivation {
  name = "print-reexports";
  src = stdenv.lib.sourceFilesBySuffices ./. [".c"];

  buildInputs = [ libyaml ];

  buildPhase = ''
    $CC -lyaml -o $name main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $name $out/bin
  '';
}
