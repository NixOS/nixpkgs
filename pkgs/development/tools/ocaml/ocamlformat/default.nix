{ lib, fetchurl, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocamlformat";
  version = "0.13.0";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}-2.tbz";
    sha256 = "0ki2flqi3xkhw9mfridivb6laxm7gml8rj9qz42vqmy9yx76jjxq";
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
