{ stdenv, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vim";
      publisher = "vscodevim";
      version = "0.16.14";
      sha256 = "0b8d3sj3754l3bwcb5cdn2z4z0nv6vj2vvaiyhrjhrc978zw7mby";
    };

    meta = with stdenv.lib; {
      description = ''
        Vim emulation for Visual Studio Code
      '';
      license = licenses.mit;
      maintainers = with maintainers; [
        garbas
      ];
    };
  }
