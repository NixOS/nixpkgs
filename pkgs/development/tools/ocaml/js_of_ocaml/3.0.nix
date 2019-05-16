{ stdenv, ocaml, findlib, dune, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned, uchar
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune ocaml-migrate-parsetree ppx_tools_versioned ];

  postPatch = "patchShebangs lib/generate_stubs.sh";

	propagatedBuildInputs = [ js_of_ocaml-compiler uchar ];

	buildPhase = "dune build -p js_of_ocaml";
}
