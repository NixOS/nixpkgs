{ stdenv, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-theme-onelight";
      publisher = "akamud";
      version = "2.1.0";
      sha256 = "1dx08r35bxvmas1ai02v9r25hxadmvm1fh50grq2r4fzqxjgxkqn";
    };

    meta = with stdenv.lib; {
      description = ''
        VSCode Theme based on Atom's One Light theme.
      '';
      license = licenses.mit;
      maintainers = with maintainers; [
        garbas
      ];
    };
  }
