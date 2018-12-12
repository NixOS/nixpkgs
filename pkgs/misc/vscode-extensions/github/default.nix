{ stdenv, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-pull-request-github";
      publisher = "github";
      version = "0.3.1";
      sha256 = "16d8lkq0jyv4n9cysrmzlfi32bdy96dx3qsq4w971yr3r9xhqhzx";
    };

    meta = with stdenv.lib; {
      description = ''
        Pull Request Provider for GitHub
      '';
      license = licenses.mit;
      maintainers = with maintainers; [
        garbas
      ];
    };
  }
