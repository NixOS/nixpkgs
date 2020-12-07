{ buildDunePackage, js_of_ocaml-compiler, js_of_ocaml-ppx
, ocaml-migrate-parsetree, ppx_tools_versioned
, js_of_ocaml, ocaml_lwt, lwt_log
}:

buildDunePackage {
  pname = "js_of_ocaml-lwt";

  inherit (js_of_ocaml-compiler) version src meta useDune2;

  buildInputs = [ js_of_ocaml-ppx ocaml-migrate-parsetree ppx_tools_versioned ];

  propagatedBuildInputs = [ js_of_ocaml ocaml_lwt lwt_log ];
}
