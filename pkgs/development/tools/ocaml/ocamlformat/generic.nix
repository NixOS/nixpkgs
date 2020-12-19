{ lib, fetchurl, fetchzip, ocaml-ng
, version
, tarballName ? "ocamlformat-${version}.tbz",
}:

let src =
  if version == "0.11.0"
  then fetchzip {
    url = "https://github.com/ocaml-ppx/ocamlformat/archive/0.11.0.tar.gz";
    sha256 = "0zvjn71jd4d3znnpgh0yphb2w8ggs457b6bl6cg1fmpdgxnds6yx";
  } else fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/${tarballName}";
    sha256 = {
      "0.12" = "1zi8x597dhp2822j6j28s84yyiqppl7kykpwqqclx6ybypvlzdpj";
      "0.13.0" = "0ki2flqi3xkhw9mfridivb6laxm7gml8rj9qz42vqmy9yx76jjxq";
      "0.14.0" = "070c0x6z5y0lyls56zm34g8lyc093wkr0jfp50dvrkr9fk1sx2wi";
      "0.14.1" = "03wn46xib63748157xchj7gflkw5000fcjw6n89h9g82q9slazaa";
      "0.14.2" = "16phz1sg9b070p6fm8d42j0piizg05vghdjmw8aj7xm82b1pm7sz";
      "0.14.3" = "13pfakdncddm41cp61p0l98scawbvhx1q4zdsglv7ph87l7zwqfl";
      "0.15.0" = "0190vz59n6ma9ca1m3syl3mc8i1smj1m3d8x1jp21f710y4llfr6";
    }."${version}";
  }
; in

let ocamlPackages =
  if lib.versionAtLeast version "0.14.3"
  then ocaml-ng.ocamlPackages
  else ocaml-ng.ocamlPackages_4_07
; in

with ocamlPackages;

buildDunePackage rec {
  pname = "ocamlformat";
  inherit src version;

  minimumOCamlVersion = "4.06";

  useDune2 = true;

  buildInputs =
    if lib.versionAtLeast version "0.14"
    then [
      base
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
    ] else [
      base
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
    maintainers = [ lib.maintainers.Zimmi48 lib.maintainers.marsam ];
    license = lib.licenses.mit;
  };
}

