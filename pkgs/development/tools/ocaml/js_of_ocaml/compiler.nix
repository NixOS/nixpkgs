{ lib, fetchurl, buildDunePackage
, cmdliner, cppo, yojson, ppxlib
, menhir
}:

buildDunePackage rec {
  pname = "js_of_ocaml-compiler";
  version = "3.8.0";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
    sha256 = "069jyiayxcgwnips3adxb3d53mzd4rrq2783b9fgmsiyzm545lcy";
  };

  nativeBuildInputs = [ cppo menhir ];
  buildInputs = [ cmdliner ];

  configurePlatforms = [];
  propagatedBuildInputs = [ yojson ppxlib ];

  meta = {
    description = "Compiler from OCaml bytecode to Javascript";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://ocsigen.org/js_of_ocaml/";
  };
}
