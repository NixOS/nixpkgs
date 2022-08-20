{ lib, fetchurl, fetchzip, ocaml-ng
, version ? "0.24.0"
, tarballName ? "ocamlformat-${version}.tbz",
}:

let src =
  fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/${tarballName}";
    sha256 = {
      "0.19.0" = "0ihgwl7d489g938m1jvgx8azdgq9f5np5mzqwwya797hx2m4dz32";
      "0.20.0" = "sha256-JtmNCgwjbCyUE4bWqdH5Nc2YSit+rekwS43DcviIfgk=";
      "0.20.1" = "sha256-fTpRZFQW+ngoc0T6A69reEUAZ6GmHkeQvxspd5zRAjU=";
      "0.21.0" = "sha256-KhgX9rxYH/DM6fCqloe4l7AnJuKrdXSe6Y1XY3BXMy0=";
      "0.22.4" = "sha256-61TeK4GsfMLmjYGn3ICzkagbc3/Po++Wnqkb2tbJwGA=";
      "0.23.0" = "sha256-m9Pjz7DaGy917M1GjyfqG5Lm5ne7YSlJF2SVcDHe3+0=";
      "0.24.0" = "sha256-Zil0wceeXmq2xy0OVLxa/Ujl4Dtsmc4COyv6Jo7rVaM=";
    }."${version}";
  };
  ocamlPackages = ocaml-ng.ocamlPackages;
in

with ocamlPackages;

buildDunePackage {
  pname = "ocamlformat";
  inherit src version;

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  strictDeps = true;

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    base
    dune-build-info
    fix
    fpath
    menhirLib
    menhirSdk
    ocp-indent
    re
    stdio
    uuseg
    uutf
  ]
  ++ lib.optionals (lib.versionAtLeast version "0.20.0") [ ocaml-version either ]
  ++ (if lib.versionAtLeast version "0.24.0"
      then [ (odoc-parser.override { version = "2.0.0"; }) ]
      else if lib.versionAtLeast version "0.20.1"
      then [ (odoc-parser.override { version = "1.0.1"; }) ]
      else [ (odoc-parser.override { version = "0.9.0"; }) ])
  ++ (if lib.versionAtLeast version "0.21.0"
      then [ cmdliner_1_1 ]
      else [ cmdliner_1_0 ])
  ++ lib.optionals (lib.versionAtLeast version "0.22.4") [ csexp ];

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code";
    maintainers = [ lib.maintainers.Zimmi48 lib.maintainers.marsam ];
    license = lib.licenses.mit;
  };
}
