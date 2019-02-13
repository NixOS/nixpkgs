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
  bbenoist.Nix = buildVscodeMarketplaceExtension {
    mktplcRef = {
        name = "Nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    };
    meta = with stdenv.lib; {
      license = licenses.mit;
    };
  };

  ms-vscode.cpptools = callPackage ./cpptools {};

  ms-python.python = callPackage ./python {};

  WakaTime.vscode-wakatime = callPackage ./wakatime {};
}
