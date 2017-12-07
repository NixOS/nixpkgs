{ stdenv, lib, fetchurl, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeExtension buildVscodeMarketplaceExtension;
in

rec {
  nix = buildVscodeMarketplaceExtension {
    mktplcRef = {
        name = "nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    };

    # TODO: Fill meta with appropriate information.
  };
}