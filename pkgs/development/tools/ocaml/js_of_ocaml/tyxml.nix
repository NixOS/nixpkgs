{ buildDunePackage, js_of_ocaml-compiler
, js_of_ocaml-ppx
, js_of_ocaml, reactivedata, tyxml
}:

buildDunePackage {
  pname = "js_of_ocaml-tyxml";

  inherit (js_of_ocaml-compiler) version src;

  buildInputs = [ js_of_ocaml-ppx ];

  propagatedBuildInputs = [ js_of_ocaml reactivedata tyxml ];

  meta = builtins.removeAttrs js_of_ocaml-compiler.meta [ "mainProgram" ];
}
