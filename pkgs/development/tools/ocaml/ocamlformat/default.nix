{ lib, fetchurl, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocamlformat";
  version = "0.13.0";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}.tbz";
    sha256 = "09y6sfkqfrgxbmphz5q8w7mdlj8fjsrkiapcx86f94dnwz6j3ajf";
  };

  buildInputs = [
    cmdliner
    fpath
    ocaml-migrate-parsetree
    odoc
    re
    stdio
    uuseg
    uutf
  ];

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code";
    maintainers = [ lib.maintainers.Zimmi48 ];
    license = lib.licenses.mit;
  };
}
