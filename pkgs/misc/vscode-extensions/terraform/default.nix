{ lib, fetchurl, vscode-utils, terraform-ls }:
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.8.0";
  };

  vsix = fetchurl {
    name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
    url = "https://github.com/hashicorp/vscode-terraform/releases/download/v${mktplcRef.version}/terraform-${mktplcRef.version}.vsix";
    sha256 = "1ns40xaswqhngprlpf3ck59mj3kcxngr4jk0wkf16j3cvvskn0yy";
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
