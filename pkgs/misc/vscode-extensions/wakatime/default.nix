{ stdenv
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "2.1.2";
      sha256 = "1cdxmqdz8h9snx25cm3phipxdhjbcn38yfab09in661nr768vrkv";
    };

    postPatch = ''
      mkdir -p wakatime-master
      cp -rt wakatime-master --no-preserve=all ${wakatime}/lib/python*/site-packages/wakatime
    '';

    meta = with stdenv.lib; {
      description = ''
        Visual Studio Code plugin for automatic time tracking and metrics generated
        from your programming activity
      '';
      license = licenses.bsd3;
      maintainers = with maintainers; [
        eadwu
      ];
    };
  }
