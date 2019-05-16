{ stdenv
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "2.1.0";
      sha256 = "0a23l8vaj0yghfh9lbi453vjghaxgjmphfjy2s4lgrvq38j4bv9n";
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
