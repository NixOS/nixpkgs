{ stdenv, ocaml, findlib, dune, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-ppx-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune ocaml-migrate-parsetree ppx_tools_versioned js_of_ocaml ];

	buildPhase = "dune build -p js_of_ocaml-ppx";
}
