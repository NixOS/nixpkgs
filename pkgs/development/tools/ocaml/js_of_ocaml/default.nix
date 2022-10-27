{ buildDunePackage, js_of_ocaml-compiler
, ppxlib, uchar
}:

buildDunePackage {
  pname = "js_of_ocaml";

  inherit (js_of_ocaml-compiler) version src useDune2;

  buildInputs = [ ppxlib ];

  propagatedBuildInputs = [ js_of_ocaml-compiler uchar ];

  meta = builtins.removeAttrs js_of_ocaml-compiler.meta [ "mainProgram" ];
}
