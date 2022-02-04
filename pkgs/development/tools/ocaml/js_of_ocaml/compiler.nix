{ lib, fetchurl, buildDunePackage
, cmdliner, yojson, ppxlib
, menhir, menhirLib
}:

buildDunePackage rec {
  pname = "js_of_ocaml-compiler";
  version = "3.11.0";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
    sha256 = "sha256:0flws9mw0yjfw4d8d3y3k408mivy2xgky70xk1br3iqs4zksz38m";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner ppxlib ];

  configurePlatforms = [];
  propagatedBuildInputs = [ menhirLib yojson ];

  meta = {
    description = "Compiler from OCaml bytecode to Javascript";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://ocsigen.org/js_of_ocaml/";
  };
}
