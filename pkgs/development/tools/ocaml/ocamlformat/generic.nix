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
      "0.15.1" = "1x6fha495sgk4z05g0p0q3zfqm5l6xzmf6vjm9g9g7c820ym2q9a";
      "0.16.0" = "1vwjvvwha0ljc014v8jp8snki5zsqxlwd7x0dl0rg2i9kcmwc4mr";
      "0.17.0" = "0f1lxp697yq61z8gqxjjaqd2ns8fd1vjfggn55x0gh9dx098p138";
      "0.18.0" = "0571kzmb1h03qj74090n3mg8wfbh29qqrkdjkai6rnl5chll86lq";
      "0.19.0" = "0ihgwl7d489g938m1jvgx8azdgq9f5np5mzqwwya797hx2m4dz32";
      "0.20.0" = "sha256-JtmNCgwjbCyUE4bWqdH5Nc2YSit+rekwS43DcviIfgk=";
      "0.20.1" = "sha256-fTpRZFQW+ngoc0T6A69reEUAZ6GmHkeQvxspd5zRAjU=";
    }."${version}";
  };
  ocamlPackages =
  if lib.versionAtLeast version "0.19.0"
  then ocaml-ng.ocamlPackages
  else if lib.versionAtLeast version "0.17.0"
  then ocaml-ng.ocamlPackages_4_12
  else if lib.versionAtLeast version "0.14.3"
  then ocaml-ng.ocamlPackages_4_10
  else ocaml-ng.ocamlPackages_4_07
; in

with ocamlPackages;

buildDunePackage {
  pname = "ocamlformat";
  inherit src version;

  minimumOCamlVersion =
    if lib.versionAtLeast version "0.17.0"
    then "4.08"
    else "4.06";

  useDune2 = true;

  strictDeps = true;

  nativeBuildInputs = [
    menhir
  ];

  buildInputs =
    if lib.versionAtLeast version "0.20.0"
    then [
      base
      cmdliner
      dune-build-info
      either
      fix
      fpath
      menhirLib
      menhirSdk
      ocaml-version
      ocp-indent
      (if version == "0.20.0" then odoc-parser.override { version = "0.9.0"; } else odoc-parser)
      re
      stdio
      uuseg
      uutf
    ]
    else if lib.versionAtLeast version "0.19.0"
    then [
      base
      cmdliner
      fpath
      re
      stdio
      uuseg
      uutf
      fix
      menhirLib
      menhirSdk
      ocp-indent
      dune-build-info
      (odoc-parser.override { version = "0.9.0"; })
    ]
    else if lib.versionAtLeast version "0.18.0"
    then [
      base
      cmdliner
      fpath
      odoc
      re
      stdio
      uuseg
      uutf
      fix
      menhirLib
      menhirSdk
      dune-build-info
      ocaml-version
      # Changed since 0.16.0:
      (ppxlib.override { version = "0.22.0"; })
    ]
    else if lib.versionAtLeast version "0.17.0"
    then [
      base
      cmdliner
      fpath
      odoc
      re
      stdio
      uuseg
      uutf
      fix
      menhirLib
      menhirSdk
      dune-build-info
      ocaml-version
      # Changed since 0.16.0:
      (ppxlib.override { version = "0.22.0"; })
      ocaml-migrate-parsetree-2
    ]
    else if lib.versionAtLeast version "0.15.1"
    then [
      base
      cmdliner
      fpath
      odoc
      re
      stdio
      uuseg
      uutf
      fix
      menhirLib
      menhirSdk
      (ppxlib.override { version = "0.18.0"; })
      dune-build-info # lib.versionAtLeast version "0.16.0"
      ocaml-version # lib.versionAtLeast version "0.16.0"
    ]
    else if lib.versionAtLeast version "0.14"
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
      menhirLib
      menhirSdk
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

