{ lib, fetchurl, buildDunePackage
, cmdliner, yojson, ppxlib
, menhir, menhirLib
}:

buildDunePackage rec {
  pname = "js_of_ocaml-compiler";
  version = "4.0.0";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
    sha256 = "sha256-3wL4GeWy9II0rys+PnyXga+oIS+L7Ofrz72DWLOUSV4=";
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
