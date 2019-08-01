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
      version = "0.0.27"; # see the note above
      sha256 = "1mz0h5zd295i73hbji9ivla8hx02i4yhqcv6l4r23w3f07ql3i8h";
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

  formulahendry.auto-close-tag = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "auto-close-tag";
      publisher = "formulahendry";
      version = "0.5.6";
      sha256 = "058jgmllqb0j6gg5anghdp35nkykii28igfcwqgh4bp10pyvspg0";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  justusadam.language-haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "language-haskell";
      publisher = "justusadam";
      version = "2.6.0"; # see the note above
      sha256 = "1891pg4x5qkh151pylvn93c4plqw6vgasa4g40jbma5xzq8pygr4";
    };
    meta = {
      license = stdenv.lib.licenses.bsd3;
    };
  };

  ms-vscode.cpptools = callPackage ./cpptools {};

  ms-python.python = callPackage ./python {
    extractNuGet = callPackage ./python/extract-nuget.nix { };
  };

  vscodevim.vim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vim";
      publisher = "vscodevim";
      version = "1.3.0";
      sha256 = "18z24w7smjjnv945f8qyy6dl95xckyqa6gg3gijfcigvq5sgyawc";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  llvm-org.lldb-vscode = llvmPackages_8.lldb;

  WakaTime.vscode-wakatime = callPackage ./wakatime {};
}
