{ stdenv
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "1.3.0";
      sha256 = "1g0k2hl3wb1rnjxvp7a1j6m200z92878ifb17h2ll69rlpmwcfqr";
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
