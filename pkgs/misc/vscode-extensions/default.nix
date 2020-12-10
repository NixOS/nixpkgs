{ stdenv, config, lib, callPackage, vscode-utils, nodePackages,llvmPackages_8, llvmPackages_latest }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  #
  # Unless there is a good reason not to, we attempt to use the same name as the
  # extension's unique identifier (the name the extension gets when installed
  # from vscode under `~/.vscode`) and found on the marketplace extension page.
  # So an extension's attribute name should be of the form:
  # "${mktplcRef.publisher}.${mktplcRef.name}".
  #
  baseExtensions = self: stdenv.lib.mapAttrs (_n: stdenv.lib.recurseIntoAttrs)
    {
      a5huynh.vscode-ron = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ron";
          publisher = "a5huynh";
          version = "0.9.0";
          sha256 = "0d3p50mhqp550fmj662d3xklj14gvzvhszm2hlqvx4h28v222z97";
        };
        meta = {
          license = stdenv.lib.licenses.mit;
        };
      };

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

      ms-python.vscode-pylance = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pylance";
          publisher = "MS-python";
          version = "2020.11.2";
          sha256 = "0n2dm21vgzir3hx1m3pmx7jq4zy3hdxfsandd2wv5da4fs9b5g50";
        };

        buildInputs = [ nodePackages.pyright ];

        meta = {
          license = stdenv.lib.licenses.unfree;
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

      golang.Go = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Go";
          publisher = "golang";
          version = "0.18.1";
          sha256 = "sha256-b2Wa3TULQQnBm1/xnDCB9SZjE+Wxz5wBttjDEtf8qlE=";
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

      mskelton.one-dark-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "one-dark-theme";
          publisher = "mskelton";
          version = "1.7.2";
          sha256 = "1ks6z8wsxmlfhiwa51f7d6digvw11dlxc7mja3hankgxcf5dyj31";
        };
        meta = {
          license = stdenv.lib.licenses.mit;
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

      ms-vscode.cpptools = callPackage ./cpptools {};

      ms-vscode-remote.remote-ssh = callPackage ./remote-ssh {};

      ms-python.python = callPackage ./python {
        extractNuGet = callPackage ./python/extract-nuget.nix { };
      };

      naumovs.color-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "color-highlight";
          publisher = "naumovs";
          version = "2.3.0";
          sha256 = "1syzf43ws343z911fnhrlbzbx70gdn930q67yqkf6g0mj8lf2za2";
        };
        meta = {
          license = stdenv.lib.licenses.mit;
        };
      };

      redhat.vscode-yaml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "0.13.0";
          sha256 = "046kdk73a5xbrwq16ff0l64271c6q6ygjvxaph58z29gyiszfkig";
        };
        meta = {
          license = stdenv.lib.licenses.mit;
        };
      };

      matklad.rust-analyzer = callPackage ./rust-analyzer {};

      pkief.material-icon-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-icon-theme";
          publisher = "pkief";
          version = "4.4.0";
          sha256 = "1m9mis59j9xnf1zvh67p5rhayaa9qxjiw9iw847nyl9vsy73w8ya";
        };
        meta = {
          license = stdenv.lib.licenses.mit;
        };
      };

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
          version = "1.9.7";
          sha256 = "0v599yssvk358gxfxnyzzkyk0y5krsbp8n4rkp9wb2ncxqsqladr";
        };
        meta = {
          license = stdenv.lib.licenses.asl20;
        };
      };

      serayuzgur.crates = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "crates";
          publisher = "serayuzgur";
          version = "0.5.3";
          sha256 = "1xk7ayv590hsm3scqpyh6962kvgdlinnpkx0vapr7vs4y08dx72f";
        };
        meta = {
          license = stdenv.lib.licenses.mit;
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

      tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "even-better-toml";
          publisher = "tamasfe";
          version = "0.9.3";
          sha256 = "16x2y58hkankazpwm93j8lqdn3mala7iayck548kki9zx4qrhhck";
        };
        meta = {
          license = stdenv.lib.licenses.mit;
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
    };

    aliases = self: super: {
      # aliases
      ms-vscode = lib.recursiveUpdate super.ms-vscode { inherit (super.golang) Go; };
    };

    # TODO: add overrides overlay, so that we can have a generated.nix
    # then apply extension specific modifcations to packages.

    # overlays will be applied left to right, overrides should come after aliases.
    overlays = lib.optionals (config.allowAliases or true) [ aliases ];

    toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
  lib.fix toFix
