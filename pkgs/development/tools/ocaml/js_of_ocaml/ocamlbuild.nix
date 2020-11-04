{ stdenv, ocaml, findlib, dune_2, js_of_ocaml-compiler
, ocamlbuild
}:

stdenv.mkDerivation {
	pname = "js_of_ocaml-ocamlbuild"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib dune_2 ];

	propagatedBuildInputs = [ ocamlbuild ];

	buildPhase = "dune build -p js_of_ocaml-ocamlbuild";
}
