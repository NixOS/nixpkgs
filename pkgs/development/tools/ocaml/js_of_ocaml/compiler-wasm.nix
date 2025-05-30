{
  lib,
  buildDunePackage,
  binaryen,
  cmdliner,
  js_of_ocaml-compiler,
  menhir,
  menhirLib,
  ppxlib,
  sedlex,
  yojson,
}:

buildDunePackage {
  pname = "wasm_of_ocaml-compiler";
  inherit (js_of_ocaml-compiler) version src;
  minimalOCamlVersion = "4.12";

  nativeBuildInputs = [
    binaryen
    menhir
  ];

  buildInputs = [
    cmdliner
    ppxlib
  ];

  propagatedBuildInputs = [
    js_of_ocaml-compiler
    menhirLib
    sedlex
    yojson
  ];

  meta = js_of_ocaml-compiler.meta // {
    description = "Compiler from OCaml bytecode to WebAssembly";
    mainProgram = "wasm_of_ocaml";
    maintainers = [ lib.maintainers.stepbrobd ];
  };
}
