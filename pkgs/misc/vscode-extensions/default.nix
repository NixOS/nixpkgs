{ config, lib, callPackage, vscode-utils, nodePackages,llvmPackages_8, llvmPackages_latest }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  #
  # Unless there is a good reason not to, we attempt to use the same name as the
  # extension's unique identifier (the name the extension gets when installed
  # from vscode under `~/.vscode`) and found on the marketplace extension page.
  # So an extension's attribute name should be of the form:
  # "${mktplcRef.publisher}.${mktplcRef.name}".
  #
  baseExtensions = self: lib.mapAttrs (_n: lib.recurseIntoAttrs)
    {
      a5huynh.vscode-ron = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ron";
          publisher = "a5huynh";
          version = "0.9.0";
          sha256 = "0d3p50mhqp550fmj662d3xklj14gvzvhszm2hlqvx4h28v222z97";
        };
        meta = {
          license = lib.licenses.mit;
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
          license = lib.licenses.mit;
        };
      };

      alexdima.copy-relative-path = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "copy-relative-path";
          publisher = "alexdima";
          version = "0.0.2";
          sha256 = "06g601n9d6wyyiz659w60phgm011gn9jj5fy0gf5wpi2bljk3vcn";
        };
        meta = {
          license = lib.licenses.mit;
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
          license = lib.licenses.unfree;
        };
      };

      bbenoist.Nix = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Nix";
          publisher = "bbenoist";
          version = "1.0.1";
          sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      brettm12345.nixfmt-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nixfmt-vscode";
          publisher = "brettm12345";
          version = "0.0.1";
          sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
        };
        meta = with lib; {
          license = licenses.mpl20;
        };
      };

      cmschuetz12.wal = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "wal";
          publisher = "cmschuetz12";
          version = "0.1.0";
          sha256 = "0q089jnzqzhjfnv0vlb5kf747s3mgz64r7q3zscl66zb2pz5q4zd";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      CoenraadS.bracket-pair-colorizer = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/CoenraadS.bracket-pair-colorizer/changelog";
          description = "A customizable extension for colorizing matching brackets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer";
          homepage = "https://github.com/CoenraadS/BracketPair";
          license = licenses.mit;
          maintainers = with maintainers; [ superherointj ];
        };
        mktplcRef = {
          name = "bracket-pair-colorizer";
          publisher = "CoenraadS";
          version = "1.0.61";
          sha256 = "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652";
        };
      };

      coenraads.bracket-pair-colorizer-2 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bracket-pair-colorizer-2";
          publisher = "CoenraadS";
          version = "0.2.0";
          sha256 = "0nppgfbmw0d089rka9cqs3sbd5260dhhiipmjfga3nar9vp87slh";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      davidanson.vscode-markdownlint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-markdownlint";
          publisher = "DavidAnson";
          version = "0.38.0";
          sha256 = "0d6hbsjrx1j8wrmfnvdwsa7sci1brplgxwkmy6sp74va7zxfjnqv";
        };
        meta = with lib; {
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
        meta = { license = lib.licenses.mit; };
      };

      dhall.vscode-dhall-lsp-server = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-dhall-lsp-server";
          publisher = "dhall";
          version = "0.0.4";
          sha256 = "1zin7s827bpf9yvzpxpr5n6mv0b5rhh3civsqzmj52mdq365d2js";
        };
        meta = { license = lib.licenses.mit; };
      };

      donjayamanne.githistory = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/donjayamanne.githistory/changelog";
          description = "View git log, file history, compare branches or commits";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory";
          homepage = "https://github.com/DonJayamanne/gitHistoryVSCode/";
          license = licenses.mit;
          maintainers = with maintainers; [ superherointj ];
        };
        mktplcRef = {
          name = "githistory";
          publisher = "donjayamanne";
          version = "0.6.14";
          sha256 = "11x116hzqnhgbryp2kqpki1z5mlnwxb0ly9r1513m5vgbisrsn0i";
        };
      };

      eamodio.gitlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlens";
          publisher = "eamodio";
          version = "11.1.3";
          sha256 = "sha256-hqJg3jP4bbXU4qSJOjeKfjkPx61yPDMsQdSUVZObK/U=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      elmtooling.elm-ls-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elm-ls-vscode";
          publisher = "Elmtooling";
          version = "2.0.1";
          sha256 = "06x5ld2r1hzns2s052mvhmfiaawjzcn0jf5lkfprhmrkxnmfdd43";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Elmtooling.elm-ls-vscode/changelog";
          description = "Elm language server";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode";
          homepage = "https://github.com/elm-tooling/elm-language-client-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ mcwitt ];
        };
      };

      esbenp.prettier-vscode = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/esbenp.prettier-vscode/changelog";
          description = "Code formatter using prettier";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode";
          homepage = "https://github.com/prettier/prettier-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ superherointj ];
        };
        mktplcRef = {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "5.8.0";
          sha256 = "0h7wc4pffyq1i8vpj4a5az02g2x04y7y1chilmcfmzg2w42xpby7";
        };
      };

      file-icons.file-icons = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/file-icons.file-icons/changelog";
          description = "File-specific icons in VSCode for improved visual grepping.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=file-icons.file-icons";
          homepage = "https://github.com/file-icons/vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ superherointj ];
        };
        mktplcRef = {
          name = "file-icons";
          publisher = "file-icons";
          version = "1.0.28";
          sha256 = "1lyx0l42xhi2f3rdnjddc3mw7m913kjnchawi98i6vqsx3dv7091";
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
          license = lib.licenses.mit;
        };
      };

      formulahendry.auto-rename-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "auto-rename-tag";
          publisher = "formulahendry";
          version = "0.1.6";
          sha256 = "0cqg9mxkyf41brjq2c764w42lzyn6ffphw6ciw7xnqk1h1x8wwbs";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      freebroccolo.reasonml = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/freebroccolo.reasonml/changelog";
          description = "Reason support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=freebroccolo.reasonml";
          homepage = "https://github.com/reasonml-editor/vscode-reasonml";
          license = licenses.asl20;
          maintainers = with maintainers; [ superherointj ];
        };
        mktplcRef = {
          name = "reasonml";
          publisher = "freebroccolo";
          version = "1.0.38";
          sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
        };
      };

      github.github-vscode-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "github-vscode-theme";
          publisher = "github";
          version = "1.1.5";
          sha256 = "10f0098cce026d1f0c855fb7a66ea60b5d8acd2b76126ea94fe7361e49cd9ed2";
        };
        meta = with lib; {
          description = "GitHub theme for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme";
          homepage = "https://github.com/primer/github-vscode-theme";
          license = licenses.mit;
          maintainers = with maintainers; [ hugolgst ];
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
          license = lib.licenses.mit;
        };
      };

      graphql.vscode-graphql = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-graphql";
          publisher = "GraphQL";
          version = "0.3.13";
          sha256 = "sha256-JjEefVHQUYidUsr8Ce/dh7hLDm21WkyS+2RwsXHoY04=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      gruntfuggly.todo-tree = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.196";
          sha256 = "1l4f290018f2p76q6hn2b2injps6wz65as7dm537wrsvsivyg2qz";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      haskell.haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "haskell";
          publisher = "haskell";
          version = "1.1.0";
          sha256 = "1wg06lyk0qn9jd6gi007sg7v0z9z8gwq7x2449d4ihs9n3w5l0gb";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      hookyqr.beautify = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "beautify";
          publisher = "HookyQR";
          version = "1.5.0";
          sha256 = "1c0kfavdwgwham92xrh0gnyxkrl9qlkpv39l1yhrldn8vd10fj5i";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      ibm.output-colorizer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "output-colorizer";
          publisher = "IBM";
          version = "0.1.2";
          sha256 = "0i9kpnlk3naycc7k8gmcxas3s06d67wxr3nnyv5hxmsnsx5sfvb7";
        };
        meta = with lib; {
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
        meta = with lib; {
          license = licenses.mit;
        };
      };

      jnoortheen.nix-ide = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/jnoortheen.nix-ide/changelog";
          description = "Nix language support with formatting and error report";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide";
          homepage = "https://github.com/jnoortheen/vscode-nix-ide";
          license = licenses.mit;
          maintainers = with maintainers; [ superherointj ];
        };
        mktplcRef = {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.1.7";
          sha256 = "1bw4wyq9abimxbhl7q9g8grvj2ax9qqq6mmqbiqlbsi2arvk0wrm";
        };
      };

      jock.svg = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svg";
          publisher = "jock";
          version = "1.4.4";
          sha256 = "0kn2ic7pgbd4rbvzpsxfwyiwxa1iy92l0h3jsppxc8gk8xbqm2nc";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      jpoissonnier.vscode-styled-components = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-styled-components";
          publisher = "jpoissonnier";
          version = "1.4.1";
          sha256 = "sha256-ojbeuYBCS+DjF5R0aLuBImzoSOb8mXw1s0Uh0CzggzE=";
        };
        meta = {
          license = lib.licenses.mit;
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
          license = lib.licenses.bsd3;
        };
      };

      mikestead.dotenv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dotenv";
          publisher = "mikestead";
          version = "1.0.1";
          sha256 = "sha256-dieCzNOIcZiTGu4Mv5zYlG7jLhaEsJR05qbzzzQ7RWc=";
        };
        meta = {
          license = lib.licenses.mit;
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
          license = lib.licenses.mit;
        };
      };

      mechatroner.rainbow-csv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "rainbow-csv";
          publisher = "mechatroner";
          version = "1.7.1";
          sha256 = "0w5mijs4ll5qjkpyw7qpn1k40pq8spm0b3q72x150ydbcini5hxw";
        };
        meta = {
          license = lib.licenses.mit;
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
          license = lib.licenses.mit;
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
          license = lib.licenses.mit;
        };
      };

      ms-vscode.cpptools = callPackage ./cpptools {};

      ms-vscode-remote.remote-ssh = callPackage ./remote-ssh {};

      ms-python.python = callPackage ./python {
        extractNuGet = callPackage ./python/extract-nuget.nix { };
      };

      msjsdiag.debugger-for-chrome = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "debugger-for-chrome";
          publisher = "msjsdiag";
          version = "4.12.11";
          sha256 = "sha256-9i3TgCFThnFF5ccwzS4ATj5c2Xoe/4tDFGv75jJxeQ4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      naumovs.color-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "color-highlight";
          publisher = "naumovs";
          version = "2.3.0";
          sha256 = "1syzf43ws343z911fnhrlbzbx70gdn930q67yqkf6g0mj8lf2za2";
        };
        meta = {
          license = lib.licenses.mit;
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
          license = lib.licenses.mit;
        };
      };

      rubymaniac.vscode-paste-and-indent = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-paste-and-indent";
          publisher = "Rubymaniac";
          version = "0.0.8";
          sha256 = "0fqwcvwq37ndms6vky8jjv0zliy6fpfkh8d9raq8hkinfxq6klgl";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      matklad.rust-analyzer = callPackage ./rust-analyzer {};

      ocamllabs.ocaml-platform = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/ocamllabs.ocaml-platform/changelog";
          description = "Official OCaml Support from OCamlLabs";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform";
          homepage = "https://github.com/ocamllabs/vscode-ocaml-platform";
          license = licenses.isc;
          maintainers = with maintainers; [ superherointj ];
        };
        mktplcRef = {
          name = "ocaml-platform";
          publisher = "ocamllabs";
          version = "1.5.1";
          sha256 = "0jkxpcrbr8xmwfl8jphmarjz2jk54hvmc24ww89d4bgx1awayqfh";
        };
      };

      pkief.material-icon-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-icon-theme";
          publisher = "pkief";
          version = "4.4.0";
          sha256 = "1m9mis59j9xnf1zvh67p5rhayaa9qxjiw9iw847nyl9vsy73w8ya";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ryu1kn.partial-diff = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "partial-diff";
          publisher = "ryu1kn";
          version = "1.4.1";
          sha256 = "1r4kg4slgxncdppr4fn7i5vfhvzcg26ljia2r97n6wvwn8534vs9";
        };
        meta = {
          license = lib.licenses.mit;
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
          license = lib.licenses.mit;
        };
      };

      scalameta.metals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "metals";
          publisher = "scalameta";
          version = "1.9.10";
          sha256 = "1afmqzlw3bl9bv59l9b2jrljhbq8djb7vl8rjv58c5wi7nvm2qab";
        };
        meta = {
          license = lib.licenses.asl20;
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
          license = lib.licenses.mit;
        };
      };

      skyapps.fish-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "fish-vscode";
          publisher = "skyapps";
          version = "0.2.1";
          sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      spywhere.guides = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "guides";
          publisher = "spywhere";
          version = "0.9.3";
          sha256 = "1kvsj085w1xax6fg0kvsj1cizqh86i0pkzpwi0sbfvmcq21i6ghn";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      streetsidesoftware.code-spell-checker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "code-spell-checker";
          publisher = "streetsidesoftware";
          version = "1.10.2";
          sha256 = "1ll046rf5dyc7294nbxqk5ya56g2bzqnmxyciqpz2w5x7j75rjib";
        };
        meta = with lib; {
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
          license = lib.licenses.mit;
        };
      };

      tyriar.sort-lines = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "sort-lines";
          publisher = "Tyriar";
          version = "1.9.0";
          sha256 = "0l4wibsjnlbzbrl1wcj18vnm1q4ygvxmh347jvzziv8f1l790qjl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vadimcn.vscode-lldb = callPackage ./vscode-lldb {
        lldb = llvmPackages_latest.lldb;
      };

      vincaslt.highlight-matching-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "highlight-matching-tag";
          publisher = "vincaslt";
          version = "0.10.0";
          sha256 = "1albwz3lc9i20if77inm1ipwws8apigvx24rbag3d1h3p4vwda49";
        };
        meta = {
          license = lib.licenses.mit;
        };
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
          license = lib.licenses.mit;
        };
      };

      xaver.clang-format = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "clang-format";
          publisher = "xaver";
          version = "1.9.0";
          sha256 = "abd0ef9176eff864f278c548c944032b8f4d8ec97d9ac6e7383d60c92e258c2f";
        };
        meta = with lib; {
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
