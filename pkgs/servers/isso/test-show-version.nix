{ stdenv, isso }:

stdenv.mkDerivation {
  name = "isso-test-show-version";
  meta.timeout = 10;
  buildCommand = ''
    ${isso}/bin/isso --version | grep "${isso.version}"
    touch $out
  '';
}

