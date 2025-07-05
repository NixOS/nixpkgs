{
  buildDunePackage,
  js_of_ocaml,
  ppxlib,
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx";

  inherit (js_of_ocaml) version src meta;

  buildInputs = [ js_of_ocaml ];
  propagatedBuildInputs = [ ppxlib ];
}
