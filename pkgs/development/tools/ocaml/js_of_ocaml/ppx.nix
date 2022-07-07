{ buildDunePackage, js_of_ocaml-compiler
, ppxlib
, js_of_ocaml
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx";

  inherit (js_of_ocaml-compiler) version src useDune2;

  buildInputs = [ js_of_ocaml ];
  propagatedBuildInputs = [ ppxlib ];

  meta = builtins.removeAttrs js_of_ocaml-compiler.meta [ "mainProgram" ];
}
