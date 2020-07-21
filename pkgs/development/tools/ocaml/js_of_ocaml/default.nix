{ stdenv, ocaml, findlib, dune_2, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned, uchar
}:

stdenv.mkDerivation {
  pname = "js_of_ocaml"; 

  inherit (js_of_ocaml-compiler) version src installPhase meta;

  buildInputs = [ findlib ocaml-migrate-parsetree ppx_tools_versioned ];
  nativeBuildInputs = [ ocaml findlib dune_2 ];

  postPatch = "patchShebangs lib/generate_stubs.sh";

	propagatedBuildInputs = [ js_of_ocaml-compiler uchar ];

	buildPhase = "dune build -p js_of_ocaml";
}
