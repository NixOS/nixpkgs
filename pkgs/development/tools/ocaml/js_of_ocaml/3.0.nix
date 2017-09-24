{ stdenv, ocaml, findlib, jbuilder, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned, uchar
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder ocaml-migrate-parsetree ppx_tools_versioned ];

  postPatch = "patchShebangs lib/generate_stubs.sh";

	propagatedBuildInputs = [ js_of_ocaml-compiler uchar ];

	buildPhase = "jbuilder build -p js_of_ocaml";
}
