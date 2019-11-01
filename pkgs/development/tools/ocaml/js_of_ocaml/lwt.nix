{ stdenv, ocaml, findlib, dune, js_of_ocaml-compiler, js_of_ocaml-ppx
, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml, ocaml_lwt, lwt_log
}:

stdenv.mkDerivation {
	pname = "js_of_ocaml-lwt"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune js_of_ocaml-ppx ocaml-migrate-parsetree ppx_tools_versioned ];

	propagatedBuildInputs = [ js_of_ocaml ocaml_lwt lwt_log ];

	buildPhase = "dune build -p js_of_ocaml-lwt";
}
