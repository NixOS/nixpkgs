{ buildDunePackage, js_of_ocaml-compiler
, js_of_ocaml, ppxlib
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx_deriving_json";

  inherit (js_of_ocaml-compiler) version src meta useDune2;

  propagatedBuildInputs = [ js_of_ocaml ppxlib ];
}
