{ lib, fetchurl, buildDunePackage
, cmdliner, yojson, ppxlib, findlib
, menhir, menhirLib, sedlex
}:

buildDunePackage rec {
  pname = "js_of_ocaml-compiler";
  version = "5.7.1";
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
    hash = "sha256-DqSOKqiQTsVi8iX6CT/2dLVODnUU2uhie4/Y93IQOD0=";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner ppxlib ];

  propagatedBuildInputs = [ menhirLib yojson findlib sedlex ];

  meta = {
    description = "Compiler from OCaml bytecode to Javascript";
    homepage = "https://ocsigen.org/js_of_ocaml/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "js_of_ocaml";
  };
}
