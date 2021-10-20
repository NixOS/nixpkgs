{ lib, fetchurl, buildDunePackage
, ocaml, cmdliner, cppo, yojson, ppxlib
, menhir, menhirLib
}:

buildDunePackage rec {
  pname = "js_of_ocaml-compiler";
  version = "3.10.0";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
    sha256 = "09k19bygxl766dmshrp5df3i99jfm8bmamb4jggm62p3hg19bzkv";
  };

  nativeBuildInputs = [ cppo menhir ];
  buildInputs = [ cmdliner menhirLib ];

  configurePlatforms = [];
  propagatedBuildInputs = [ yojson ppxlib ];

  meta = {
    description = "Compiler from OCaml bytecode to Javascript";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://ocsigen.org/js_of_ocaml/";
  };
}
