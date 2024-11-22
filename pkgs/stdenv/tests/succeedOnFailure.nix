{ stdenv }:

stdenv.mkDerivation {
  name = "stdenv-test-succeedOnFailure";

  succeedOnFailure = true;

  passAsFile = [ "buildCommand" ];
  buildCommand = ''
    mkdir $out
    echo foo > $out/foo
    exit 1
  '';
}
