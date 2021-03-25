{ buildDunePackage, js_of_ocaml-compiler
, ppxlib
, js_of_ocaml
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx";

  inherit (js_of_ocaml-compiler) version src meta useDune2;

  buildInputs = [ ppxlib js_of_ocaml ];
}
