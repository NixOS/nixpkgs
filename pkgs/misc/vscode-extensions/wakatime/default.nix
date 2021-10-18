{ lib
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "17.1.0";
      sha256 = "177q8angrn702pxrrpk1fzggzlnnaymq32v55qpjgjb74rhg4dzw";
    };

    meta = with lib; {
      description = ''
        Visual Studio Code plugin for automatic time tracking and metrics generated
        from your programming activity
      '';
      license = licenses.bsd3;
    };
  }
