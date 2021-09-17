{ lib, fetchurl, vscode-utils, terraform-ls }:
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.14.0";
  };

  vsix = fetchurl {
    name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
    url = "https://github.com/hashicorp/vscode-terraform/releases/download/v${mktplcRef.version}/${mktplcRef.name}-${mktplcRef.version}.vsix";
    sha256 = "1q43a28l6xfp3yw6wlr1kcidik0dbp8b7lg9vc83rhw4rjgvjsfm";
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
