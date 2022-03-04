{ buildDunePackage, js_of_ocaml-compiler
, ocamlbuild
}:

buildDunePackage {
  pname = "js_of_ocaml-ocamlbuild";

  inherit (js_of_ocaml-compiler) version src meta;

  minimalOCamlVersion = "4.02";

  propagatedBuildInputs = [ ocamlbuild ];
}
