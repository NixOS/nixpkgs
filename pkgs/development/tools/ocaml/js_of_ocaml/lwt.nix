{ stdenv, ocaml, findlib, jbuilder, js_of_ocaml-compiler, js_of_ocaml-ppx
, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml, ocaml_lwt
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-lwt-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder js_of_ocaml-ppx ocaml-migrate-parsetree ppx_tools_versioned ];

	propagatedBuildInputs = [ js_of_ocaml ocaml_lwt ];

	buildPhase = "jbuilder build -p js_of_ocaml-lwt";
}
