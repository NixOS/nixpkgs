{ lib, fetchurl, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocamlformat";
  version = "0.14.0";

  minimumOCamlVersion = "4.06";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}.tbz";
    sha256 = "070c0x6z5y0lyls56zm34g8lyc093wkr0jfp50dvrkr9fk1sx2wi";
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
    fix
    menhir
  ];

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code";
    maintainers = [ lib.maintainers.Zimmi48 ];
    license = lib.licenses.mit;
  };
}
