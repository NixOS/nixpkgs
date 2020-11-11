{ stdenv, callPackage, vscode-utils, llvmPackages_8, llvmPackages_latest }:

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
stdenv.lib.mapAttrs (_n: stdenv.lib.recurseIntoAttrs)
{

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

  cmschuetz12.wal = buildVscodeMarketplaceExtension {
    mktplcRef = {
        name = "wal";
        publisher = "cmschuetz12";
        version = "0.1.0";
        sha256 = "0q089jnzqzhjfnv0vlb5kf747s3mgz64r7q3zscl66zb2pz5q4zd";
    };
    meta = with stdenv.lib; {
      license = licenses.mit;
    };
  };

  dhall.dhall-lang = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "dhall-lang";
      publisher = "dhall";
      version = "0.0.4";
      sha256 = "0sa04srhqmngmw71slnrapi2xay0arj42j4gkan8i11n7bfi1xpf";
    };
    meta = { license = stdenv.lib.licenses.mit; };
  };

  dhall.vscode-dhall-lsp-server = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-dhall-lsp-server";
      publisher = "dhall";
      version = "0.0.4";
      sha256 = "1zin7s827bpf9yvzpxpr5n6mv0b5rhh3civsqzmj52mdq365d2js";
    };
    meta = { license = stdenv.lib.licenses.mit; };
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

  haskell.haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "haskell";
      publisher = "haskell";
      version = "1.1.0";
      sha256 = "1wg06lyk0qn9jd6gi007sg7v0z9z8gwq7x2449d4ihs9n3w5l0gb";
    };
    meta = with stdenv.lib; {
      license = licenses.mit;
    };
  };

  james-yu.latex-workshop = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "latex-workshop";
      publisher = "James-Yu";
      version = "8.2.0";
      sha256 = "1ai16aam4v5jzhxgms589q0l24kyk1a9in6z4i7g05b3sahyxab2";
    };
    meta = with stdenv.lib; {
      license = licenses.mit;
    };
  };

  justusadam.language-haskell = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.2.1";
      sha256 = "0lxp8xz17ciy93nj4lzxqvz71vw1zdyamrnh2n792yair8890rr6";
    };
    meta = {
      license = stdenv.lib.licenses.bsd3;
    };
  };

  ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "0.8.1";
      sha256 = "0n59whmcrx8946xix6skvc50f2vsc85ckvn8cs06w9mqmymm1q0s";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  ms-kubernetes-tools.vscode-kubernetes-tools = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-kubernetes-tools";
      publisher = "ms-kubernetes-tools";
      version = "1.0.6";
      sha256 = "12a4phl1pddsajy3n0ld6rp607iy0pif6pqrs6ljbg2x97fyra28";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  ms-vscode.Go = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "Go";
      publisher = "ms-vscode";
      version = "0.11.7";
      sha256 = "1l6jjdfivw1pn9y4d4i7zf80ls1k1b0ap1d828ah57ad3bgmyqfi";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  ms-vscode.cpptools = callPackage ./cpptools {};

  ms-vscode-remote.remote-ssh = callPackage ./remote-ssh {};

  ms-python.python = callPackage ./python {
    extractNuGet = callPackage ./python/extract-nuget.nix { };
  };

  redhat.vscode-yaml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "0.5.3";
      sha256 = "03swlsp906rqlrx6jf3ibh7pk36sm0zdr8jfy6sr3w5lqjg27gka";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  matklad.rust-analyzer = callPackage ./rust-analyzer {};

  scala-lang.scala = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "scala";
      publisher = "scala-lang";
      version = "0.4.5";
      sha256 = "0nrj32a7a86vwc9gfh748xs3mmfwbc304dp7nks61f0lx8b4wzxw";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  scalameta.metals = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "metals";
      publisher = "scalameta";
      version = "1.9.6";
      sha256 = "12sjzk64kz7z8zqh3zg1dyb3v4c5xxgi1ain1jvw8hwf0hicqlgi";
    };
    meta = {
      license = stdenv.lib.licenses.asl20;
    };
  };

  skyapps.fish-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "fish-vscode";
      publisher = "skyapps";
      version = "0.2.1";
      sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
    };
    meta = with stdenv.lib; {
      license = licenses.mit;
    };
  };

  vadimcn.vscode-lldb = callPackage ./vscode-lldb {
    lldb = llvmPackages_latest.lldb;
  };

  ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare-vsliveshare {};

  vscodevim.vim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vim";
      publisher = "vscodevim";
      version = "1.11.3";
      sha256 = "1smzsgcrkhghbnpy51gp28kh74l7y4s2m8pfxabb4ffb751254j0";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  xaver.clang-format = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "clang-format";
      publisher = "xaver";
      version = "1.9.0";
      sha256 = "abd0ef9176eff864f278c548c944032b8f4d8ec97d9ac6e7383d60c92e258c2f";
    };
    meta = with stdenv.lib; {
      license = licenses.mit;
      maintainers = [ maintainers.zeratax ];
    };
  };

  llvm-org.lldb-vscode = llvmPackages_8.lldb;

  WakaTime.vscode-wakatime = callPackage ./wakatime {};
}
