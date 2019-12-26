{ lib, fetchurl, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocamlformat";
  version = "0.12";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}.tbz";
    sha256 = "1zi8x597dhp2822j6j28s84yyiqppl7kykpwqqclx6ybypvlzdpj";
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
