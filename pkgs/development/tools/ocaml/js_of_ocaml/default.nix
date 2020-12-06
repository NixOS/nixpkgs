{ buildDunePackage, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned, uchar
}:

buildDunePackage {
  pname = "js_of_ocaml"; 

  inherit (js_of_ocaml-compiler) version src meta useDune2;

  buildInputs = [ ocaml-migrate-parsetree ppx_tools_versioned ];

	propagatedBuildInputs = [ js_of_ocaml-compiler uchar ];
}
