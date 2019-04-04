{ stdenv, callPackage, vscode-utils, llvmPackages_8 }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
#
# Unless there is a good reason not to, we attempt to use the same name as the
# extension's unique identifier (the name the extension gets when installed
# from vscode under `~/.vscode`) and found on the marketplace extension page.
# So an extension's attribute name should be of the form:
# "${mktplcRef.publisher}.${mktplcRef.name}".
#
rec {

  alanz.vscode-hie-server = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-hie-server";
      publisher = "alanz";
      version = "0.0.25"; # see the note above
      sha256 = "0m21w03v94qxm0i54ki5slh6rg7610zfxinfpngr0hfpgw2nnxvc";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  bbenoist.Nix = buildVscodeMarketplaceExtension {
    mktplcRef = {
        name = "Nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    };
    meta = with stdenv.lib; {
      license = licenses.mit;
    };
  };

  justusadam.language-haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "language-haskell";
      publisher = "justusadam";
      version = "2.5.0"; # see the note above
      sha256 = "10jqj8qw5x6da9l8zhjbra3xcbrwb4cpwc3ygsy29mam5pd8g6b3";
    };
    meta = {
      license = stdenv.lib.licenses.bsd3;
    };
  };

  ms-vscode.cpptools = callPackage ./cpptools {};

  ms-python.python = callPackage ./python {};

  vscodevim.vim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vim";
      publisher = "vscodevim";
      version = "1.2.0";
      sha256 = "0c7nv3razc3xjjzmb0q9a89dgry77h79rbkmc8nbfpa1if7lsvcp";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  llvm-org.lldb-vscode = llvmPackages_8.lldb;

  WakaTime.vscode-wakatime = callPackage ./wakatime {};
}
