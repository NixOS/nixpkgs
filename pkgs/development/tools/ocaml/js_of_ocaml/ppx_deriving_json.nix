{ stdenv, ocaml, findlib, jbuilder, js_of_ocaml-compiler
, js_of_ocaml, ppx_deriving
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-ppx_deriving_json-${version}";

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder ];

	propagatedBuildInputs = [ js_of_ocaml ppx_deriving ];

	buildPhase = "jbuilder build -p js_of_ocaml-ppx_deriving_json";
}
