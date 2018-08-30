{ stdenv, ocaml, findlib, jbuilder, js_of_ocaml-compiler
, camlp4, ocsigen_deriving
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-camlp4-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder camlp4 ocsigen_deriving ];

	buildPhase = "jbuilder build -p js_of_ocaml-camlp4";
}
