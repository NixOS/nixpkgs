{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocamlformat";
  version = "0.11.0";

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "0zvjn71jd4d3znnpgh0yphb2w8ggs457b6bl6cg1fmpdgxnds6yx";
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
    inherit (src.meta) homepage;
    description = "Auto-formatter for OCaml code";
    maintainers = [ lib.maintainers.Zimmi48 ];
    license = lib.licenses.mit;
  };
}
