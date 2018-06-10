{ stdenv, ocaml, findlib, jbuilder, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-ppx-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder ocaml-migrate-parsetree ppx_tools_versioned js_of_ocaml ];

	buildPhase = "jbuilder build -p js_of_ocaml-ppx";
}
