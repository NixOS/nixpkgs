{stdenv, fetchurl, ocaml, transitional ? false}:

let
  pname = "camlp5";
  version = "5.12";
  webpage = http://pauillac.inria.fr/~ddr/camlp5/;
in

stdenv.mkDerivation {

  name = "${pname}${if transitional then "_transitional" else ""}-${version}";

  src = fetchurl {
    url = "${webpage}/distrib/src/${pname}-${version}.tgz";
    sha256 = "985a5e373ea75f89667e71bc857c868c395769fce664cba88aa76f93b0ad8461";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  configureFlags = if transitional then "--transitional" else "--strict";

  buildFlags = "world.opt";

  meta = {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = "${webpage}";
    license = "BSD";
  };
}
