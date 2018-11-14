{ stdenv, ocaml, findlib, dune, js_of_ocaml-compiler
, ocamlbuild
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-ocamlbuild-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune ];

	propagatedBuildInputs = [ ocamlbuild ];

	buildPhase = "dune build -p js_of_ocaml-ocamlbuild";
}
