{ stdenv, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
        name = "Nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    };
    meta = with stdenv.lib; {
      description = ''
        Nix language support for Visual Studio Code.
      '';
      license = licenses.mit;
      maintainers = with maintainers; [
        garbas
      ];
    };
  }
