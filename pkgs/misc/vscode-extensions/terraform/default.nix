{ lib, vscode-utils, terraform-ls }:
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.15.0";
    sha256 = "0bqf9ry0idqw61714dc6y1rh5js35mi14q19yqhiwayyfakwraq9";
  };

  patches = [ ./fix-terraform-ls.patch ];

  postPatch = ''
    substituteInPlace out/serverPath.js --replace TERRAFORM-LS-PATH ${terraform-ls}/bin/terraform-ls
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
