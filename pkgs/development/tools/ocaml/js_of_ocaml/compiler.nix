{ lib, fetchurl, buildDunePackage
, cmdliner, yojson, ppxlib, findlib
, menhir, menhirLib, sedlex
}:

buildDunePackage rec {
  pname = "js_of_ocaml-compiler";
  version = "5.2.0";
  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
    sha256 = "sha256-ZQqwpP+mpQVxa3OtspNCj6e/1qApM0m/GGEjM4p/zrU=";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner ppxlib ];

  configurePlatforms = [];
  propagatedBuildInputs = [ menhirLib yojson findlib sedlex ];

  meta = {
    description = "Compiler from OCaml bytecode to Javascript";
    homepage = "https://ocsigen.org/js_of_ocaml/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "js_of_ocaml";
  };
}
