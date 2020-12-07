{ buildDunePackage, js_of_ocaml-compiler
, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx";

  inherit (js_of_ocaml-compiler) version src meta useDune2;

  buildInputs = [ ocaml-migrate-parsetree ppx_tools_versioned js_of_ocaml ];
}
