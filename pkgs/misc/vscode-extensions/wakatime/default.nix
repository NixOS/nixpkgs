{ stdenv, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "1.2.4";
      sha256 = "0qghn4kakv0jrjcl65p1v5r6j7608269zyhh75b15p12mdvi21vb";
    };

    postPatch = ''
      mkdir -p out/wakatime-master

      cp -rt out/wakatime-master --no-preserve=all ${wakatime}/lib/python*/site-packages/wakatime
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
