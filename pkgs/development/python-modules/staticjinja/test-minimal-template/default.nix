{ stdenv, staticjinja }:

stdenv.mkDerivation {
  name = "staticjinja-test-minimal-template";
  meta.timeout = 30;
  buildCommand = ''
    ${staticjinja}/bin/staticjinja build --srcpath ${./templates}
    grep 'Hello World!' index
    touch $out
  '';
}
