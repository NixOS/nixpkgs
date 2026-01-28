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
    lib.switch rocq-core.rocq-version [
      # When updating the default version here, also update the VsRocq VS Code extension
      (case (lib.versions.range "8.18" "9.1") "2.3.4")
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
    release."2.3.4".rev = "v2.3.4";
    release."2.3.4".sha256 = "sha256-v1hQjE8U1o2VYOlUjH0seIsNG+NrMNZ8ixt4bQNyGvI=";
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
    zarith
    ppx_inline_test
    ppx_assert
    ppx_sexp_conv
    ppx_deriving
    ppx_import
    sexplib
    (ppx_yojson_conv.override {
      ppx_yojson_conv_lib = ppx_yojson_conv_lib.override { yojson = yojson_2; };
    })
    lsp
    sel
    ppx_optcomp
  ]);
  preBuild = ''
    make dune-files
  '';

  meta = {
    description = "Language server for the vsrocq vscode/codium extension";
    homepage = "https://github.com/rocq-prover/vsrocq";
    maintainers = with lib.maintainers; [ cohencyril ];
    license = lib.licenses.mit;
  }
  // lib.optionalAttrs (fetched.broken or false) {
    broken = true;
  };
}
