{ stdenv, ocaml, findlib, dune_2, js_of_ocaml-compiler
, js_of_ocaml, ppxlib
}:

if !stdenv.lib.versionAtLeast ppxlib.version "0.14"
then throw "js_of_ocaml-ppx_deriving_json is not compatible with ppxlib ${ppxlib.version}"
else

stdenv.mkDerivation {
	pname = "js_of_ocaml-ppx_deriving_json";

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune_2 ];

	propagatedBuildInputs = [ js_of_ocaml ppxlib ];

	buildPhase = "dune build -p js_of_ocaml-ppx_deriving_json";
}
