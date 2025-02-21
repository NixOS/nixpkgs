{
  lib,
  buildDunePackage,
  binaryen,
  cmdliner,
  js_of_ocaml,
  menhir,
  menhirLib,
  menhirSdk,
  ppxlib,
  sedlex,
  yojson,
}:

buildDunePackage {
  pname = "wasm_of_ocaml-compiler";
  inherit (js_of_ocaml) version src;

  nativeBuildInputs = [
    binaryen
    menhir
  ];

  buildInputs = [
    cmdliner
    ppxlib
  ];

  propagatedBuildInputs = [
    js_of_ocaml
    menhirLib
    menhirSdk
    sedlex
    yojson
  ];

  meta = js_of_ocaml.meta // {
    description = "Compiler from OCaml bytecode to WebAssembly";
    mainProgram = "wasm_of_ocaml";
    maintainers = [ lib.maintainers.stepbrobd ];
  };
}
