{ lib, fetchurl, vscode-utils, terraform-ls }:
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.13.2";
  };

  vsix = fetchurl {
    name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
    url = "https://github.com/hashicorp/vscode-terraform/releases/download/v${mktplcRef.version}/${mktplcRef.name}-${mktplcRef.version}.vsix";
    sha256 = "0h7c6p2dcwsg7wlp49p2fsq0f164pzkx65929imd1m2df77aykqa";
  };

  patches = [ ./fix-terraform-ls.patch ];

  postPatch = ''
    substituteInPlace out/clientHandler.js --replace TERRAFORM-LS-PATH ${terraform-ls}/bin/terraform-ls
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
