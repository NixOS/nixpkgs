{ stdenv, ocaml, findlib, dune_2, js_of_ocaml-compiler
, js_of_ocaml-ppx, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml, reactivedata, tyxml
}:

stdenv.mkDerivation {
	pname = "js_of_ocaml-tyxml";

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune_2 js_of_ocaml-ppx ocaml-migrate-parsetree ppx_tools_versioned ];

	propagatedBuildInputs = [ js_of_ocaml reactivedata tyxml ];

	buildPhase = "dune build -p js_of_ocaml-tyxml";
}
