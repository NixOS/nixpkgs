{stdenv, lib, fetchFromGitHub, ocaml, makeWrapper}:

stdenv.mkDerivation (rec {

  name = "pyre-check";
  version = "0.0.6";

  src = fetchFromGitHub {
    inherit repo;
    owner = "facebook";
    rev = "${version}";
    sha256 = "0q7f5iin7ilkhs2zgkk527ryw9x1r6pnzgy1lc4d3j3vg6ifhcgc";
  };

  buildInputs = [ ocaml makeWrapper ];

  buildPhase = ''
    ./scripts/setup.sh --local
    make
  '';

  checkPhase = ''
    make test
    make python_tests
  '';
  
  # installPhase = ''
  # '';

  meta = {
    homepage = https://pyre-check.org/;
    description = "A performant type-checker for Python 3";
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; unix;
  };

})
