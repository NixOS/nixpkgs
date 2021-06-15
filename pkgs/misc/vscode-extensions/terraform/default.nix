{ lib, fetchurl, vscode-utils, terraform-ls }:
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.12.1";
  };

  vsix = fetchurl {
    name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
    url = "https://github.com/hashicorp/vscode-terraform/releases/download/v${mktplcRef.version}/${mktplcRef.name}-${mktplcRef.version}.vsix";
    sha256 = "0mna2agv2g0fw17m2swlzvj5qdqkr074n630x8yibi4ihv6z3l3y";
  };

  patches = [ ./fix-terraform-ls.patch ];

  postPatch = ''
    substituteInPlace out/extension.js --replace TERRAFORM-LS-PATH ${terraform-ls}/bin/terraform-ls
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
