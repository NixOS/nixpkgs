{ stdenv, ocaml, findlib, dune_2, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml
}:

stdenv.mkDerivation {
	pname = "js_of_ocaml-ppx"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune_2 ocaml-migrate-parsetree ppx_tools_versioned js_of_ocaml ];

	buildPhase = "dune build -p js_of_ocaml-ppx";
}
