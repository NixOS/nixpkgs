{
  metaFetch,
  coq,
  rocq-core,
  lib,
  glib,
  adwaita-icon-theme,
  wrapGAppsHook3,
  version ? null,
}:

let
  ocamlPackages = rocq-core.ocamlPackages;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (range "8.18" "9.1") "2.3.3")
      (case (range "8.18" "9.1") "2.3.0")
    ] null;
  location = {
    domain = "github.com";
    owner = "rocq-prover";
    repo = "vsrocq";
  };
  fetch = metaFetch {
    release."2.3.0".rev = "v2.3.0";
    release."2.3.0".sha256 = "sha256-BZLxcCmSGFf04eUmlJXnyxmg4hTwpFaPaIik4VD444M=";
    release."2.3.3".rev = "v2.3.3";
    release."2.3.3".sha256 = "sha256-wgn28wqWhZS4UOLUblkgXQISgLV+XdSIIEMx9uMT/ig=";
    inherit location;
  };
  fetched = fetch (if version != null then version else defaultVersion);
in
ocamlPackages.buildDunePackage {
  pname = "vsrocq-language-server";
  inherit (fetched) version;
  src = "${fetched.src}/language-server";
  nativeBuildInputs = [ coq ];
  buildInputs = [
    coq
    glib
    adwaita-icon-theme
    wrapGAppsHook3
  ]
  ++ (with ocamlPackages; [
    findlib
    lablgtk3-sourceview3
    yojson
    zarith
    ppx_inline_test
    ppx_assert
    ppx_sexp_conv
    ppx_deriving
    ppx_import
    sexplib
    ppx_yojson_conv
    lsp
    sel
    ppx_optcomp
  ]);
  preBuild = ''
    make dune-files
  '';

  meta =
    with lib;
    {
      description = "Language server for the vsrocq vscode/codium extension";
      homepage = "https://github.com/rocq-prover/vsrocq";
      maintainers = with maintainers; [ cohencyril ];
      license = licenses.mit;
    }
    // optionalAttrs (fetched.broken or false) {
      rocqFilter = true;
      broken = true;
    };
}
