{ stdenv, ocaml, findlib, dune, js_of_ocaml-compiler
, js_of_ocaml, ppx_deriving
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-ppx_deriving_json-${version}";

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune ];

	propagatedBuildInputs = [ js_of_ocaml ppx_deriving ];

	buildPhase = "dune build -p js_of_ocaml-ppx_deriving_json";
}
