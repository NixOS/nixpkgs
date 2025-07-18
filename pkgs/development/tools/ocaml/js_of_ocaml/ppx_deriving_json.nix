{
  buildDunePackage,
  js_of_ocaml,
  ppxlib,
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx_deriving_json";

  inherit (js_of_ocaml) version src meta;

  propagatedBuildInputs = [
    js_of_ocaml
    ppxlib
  ];
}
