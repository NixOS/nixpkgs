{
  buildDunePackage,
  js_of_ocaml-compiler,
  js_of_ocaml,
  ppxlib,
}:

buildDunePackage {
  pname = "js_of_ocaml-toplevel";
  inherit (js_of_ocaml-compiler) src version;
  buildInputs = [
    ppxlib
    js_of_ocaml
  ];
  propagatedBuildInputs = [ js_of_ocaml-compiler ];
  meta = js_of_ocaml-compiler.meta // {
    mainProgram = "jsoo_mktop";
  };
}
