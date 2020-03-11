{ lib
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "4.0.0";
      sha256 = "0bwxz8dg00k8frnvkvcngll5yaf9k7z13dg309vmw8xbdgkiyid4";
    };

    postUnpack = ''
      mkdir -p $sourceRoot/wakatime-master
      cp -rt $sourceRoot/wakatime-master --no-preserve=all ${wakatime}/lib/python*/site-packages/wakatime
    '';

    # Should check on every version bump
    # https://github.com/wakatime/vscode-wakatime/blob/8c5065e6c6309fb0dc0dc94d4829d738058002ea/src/dependencies.ts#L30
    postPatch = ''
      sed -i "s@\(this.standalone\)\(?this.checkAndInstallStandaloneCli(e)\)@(!this.isCliInstalled()\&\&\1)\2@" dist/extension.js
    '';

    meta = with lib; {
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
