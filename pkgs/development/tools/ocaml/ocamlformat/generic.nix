{ lib, callPackage, ocaml-ng, version ? "0.25.1" }:

with ocaml-ng.ocamlPackages;

let
  inherit (callPackage ../../../ocaml-modules/ocamlformat/generic.nix {
    inherit version;
  })
    src library_deps;

in buildDunePackage {
  pname = "ocamlformat";
  inherit src version;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  nativeBuildInputs =
    if lib.versionAtLeast version "0.25.1" then [ ] else [ menhir ];

  buildInputs = [ re ] ++ library_deps
    ++ lib.optionals (lib.versionAtLeast version "0.25.1")
    [ (ocamlformat-lib.override { inherit version; }) ];

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code";
    maintainers = with lib.maintainers; [ Zimmi48 marsam Julow ];
    license = lib.licenses.mit;
  };
}
