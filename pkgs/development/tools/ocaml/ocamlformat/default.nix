{ lib, fetchurl, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocamlformat";
  version = "0.15.0";

  minimumOCamlVersion = "4.06";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}.tbz";
    sha256 = "0190vz59n6ma9ca1m3syl3mc8i1smj1m3d8x1jp21f710y4llfr6";
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
    maintainers = [ lib.maintainers.Zimmi48 lib.maintainers.marsam ];
    license = lib.licenses.mit;
  };
}
