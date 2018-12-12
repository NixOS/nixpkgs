{ stdenv, callPackage, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
#
# Unless there is a good reason not to, we attempt to use the same name as the
# extension's unique identifier (the name the extension gets when installed
# from vscode under `~/.vscode`) and found on the marketplace extension page.
# So an extension's attribute name should be of the form:
# "${mktplcRef.publisher}.${mktplcRef.name}".
#
rec {
  WakaTime.vscode-wakatime = callPackage ./wakatime {};
  akamud.vscode-theme-onelight = callPackage ./theme-onelight {};
  bbenoist.Nix = callPackage ./nix {};
  github.vscode-pull-request-github = callPackage ./pull-request-github {};
  ms-python.python = callPackage ./python {};
  ms-vscode.cpptools = callPackage ./cpptools {};
  vscodevim.vim = callPackage ./vim {};
}
