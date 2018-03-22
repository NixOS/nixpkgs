{ stdenv, ocaml, findlib, jbuilder, js_of_ocaml-compiler
, ocamlbuild
}:

stdenv.mkDerivation rec {
	name = "js_of_ocaml-ocamlbuild-${version}"; 

	inherit (js_of_ocaml-compiler) version src installPhase meta;

	buildInputs = [ ocaml findlib jbuilder ];

	propagatedBuildInputs = [ ocamlbuild ];

	buildPhase = "jbuilder build -p js_of_ocaml-ocamlbuild";
}
