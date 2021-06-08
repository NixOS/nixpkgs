{ config, lib, buildEnv, callPackage, vscode-utils, nodePackages, jdk, llvmPackages_8, nixpkgs-fmt, jq }:

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
          sha256 = "0b1fvvlw59vh18lca2i5z6c5kll0xys48vh8cgvnhfd6vb1mpsa5";
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
          useMSMktplc = true;
          sha256 = "1mz0h5zd295i73hbji9ivla8hx02i4yhqcv6l4r23w3f07ql3i8h";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      alefragnani.project-manager = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "project-manager";
          publisher = "alefragnani";
          version = "12.1.0";
          sha256 = "sha256-fYBKmWn9pJh2V0fGdqVrXj9zIl8oTrZcBycDaMOXL/8=";
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
          useMSMktplc = true;
          sha256 = "06g601n9d6wyyiz659w60phgm011gn9jj5fy0gf5wpi2bljk3vcn";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      alygin.vscode-tlaplus = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tlaplus";
          publisher = "alygin";
          version = "1.5.3";
          sha256 = "1cn08rrqkd0nrb1gl689dir1wrm9kxfcmmxn5lgyi34hy5j74ng2";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      antfu.icons-carbon = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "icons-carbon";
          publisher = "antfu";
          version = "0.2.2";
          useMSMktplc = true;
          sha256 = "0mfap16la09mn0jhvy8s3dainrmjz64vra7d0d4fbcpgg420kv3f";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      ms-python.vscode-pylance = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pylance";
          publisher = "MS-python";
          version = "2020.11.2";
          useMSMktplc = true;
          sha256 = "0n2dm21vgzir3hx1m3pmx7jq4zy3hdxfsandd2wv5da4fs9b5g50";
        };

        buildInputs = [ nodePackages.pyright ];

        meta = {
          license = lib.licenses.unfree;
        };
      };

      b4dm4n.vscode-nixpkgs-fmt = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nixpkgs-fmt";
          publisher = "B4dM4n";
          version = "0.0.1";
          sha256 = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
        };
        nativeBuildInputs = [ jq ];
        buildInputs = [ nixpkgs-fmt ];
        postInstall = ''
          cd "$out/$installPrefix"
          tmp_package_json=$(mktemp)
          jq '.contributes.configuration.properties."nixpkgs-fmt.path".default = "${nixpkgs-fmt}/bin/nixpkgs-fmt"' package.json > "$tmp_package_json"
          mv "$tmp_package_json" package.json
        '';
        meta = with lib; {
          license = licenses.mit;
        };
      };

      baccata.scaladex-search = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "scaladex-search";
          publisher = "baccata";
          version = "0.0.1";
          useMSMktplc = true;
          sha256 = "1y8p4rr8qq5ng52g4pbx8ayq04gi2869wrx68k69rl7ga7bzcyp9";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      bbenoist.Nix = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Nix";
          publisher = "bbenoist";
          version = "1.0.1";
          sha256 = "10a2f3bgrk86zq25b120lqb237diprrqkqzq8d8d8gizx78iv899";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      bodil.file-browser = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "file-browser";
          publisher = "bodil";
          version = "0.2.10";
          sha256 = "sha256-RW4vm0Hum9AeN4Rq7MSJOIHnALU0L1tBLKjaRLA2hL8=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      bradlc.vscode-tailwindcss = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailwindcss";
          publisher = "bradlc";
          version = "0.6.6";
          sha256 = "sha256-CRd+caKHFOXBnePr/LqNkzw0kRGYvNSkf4ecNgedpdA=";
        };
        meta = with lib; {
          license = licenses.mpl20;
        };
      };

      brettm12345.nixfmt-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nixfmt-vscode";
          publisher = "brettm12345";
          version = "0.0.1";
          useMSMktplc = true;
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
          useMSMktplc = true;
          sha256 = "0q089jnzqzhjfnv0vlb5kf747s3mgz64r7q3zscl66zb2pz5q4zd";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      codezombiech.gitignore = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitignore";
          publisher = "codezombiech";
          version = "0.6.0";
          useMSMktplc = true;
          sha256 = "0gnc0691pwkd9s8ldqabmpfvj0236rw7bxvkf0bvmww32kv1ia0b";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      # The github project has been archived
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
          sha256 = "1k8afg5x39fk554dksdyrzb356h5a4dc0piak80iv7iab4xpdwgf";
        };
      };

      coenraads.bracket-pair-colorizer-2 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bracket-pair-colorizer-2";
          publisher = "CoenraadS";
          version = "0.2.0";
          # Open VFX Registry contains version 0.1.4
          # The github project has been archived
          useMSMktplc = true;
          sha256 = "0nppgfbmw0d089rka9cqs3sbd5260dhhiipmjfga3nar9vp87slh";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      dbaeumer.vscode-eslint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-eslint";
          publisher = "dbaeumer";
          version = "2.1.14";
          # Open VSX Registry contains version 2.1.8
          # See https://github.com/microsoft/vscode-eslint/issues/1042
          useMSMktplc = true;
          sha256 = "sha256-bVGmp871yu1Llr3uJ+CCosDsrxJtD4b1+CR+omMUfIQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      davidanson.vscode-markdownlint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-markdownlint";
          publisher = "DavidAnson";
          version = "0.38.0";
          sha256 = "0x5lrpm63mczy352m1hvz04wvqfc0y5jcaqcy8c9w0yhc6jl8aq6";
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
          useMSMktplc = true;
          sha256 = "0sa04srhqmngmw71slnrapi2xay0arj42j4gkan8i11n7bfi1xpf";
        };
        meta = { license = lib.licenses.mit; };
      };

      dhall.vscode-dhall-lsp-server = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-dhall-lsp-server";
          publisher = "dhall";
          version = "0.0.4";
          sha256 = "0mhy7lpf3azbvcja5dvzrijrxg4hfxh41xgw318i0hf280zxh209";
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
          sha256 = "026x58ny0dr5v61gyzvvjl6y2mfsvjrwhlbyfcd7x1yhfwsaffmc";
        };
      };

      dotjoshjohnson.xml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "xml";
          publisher = "dotjoshjohnson";
          version = "2.5.1";
          sha256 = "1jjcqgfjjw14c8kyjr3x9zkb8pilv5c3ibd3rjclfp9l91ivwpp0";
        };
        meta = {
          description = "XML Tools";
          homepage = "https://github.com/DotJoshJohnson/vscode-xml";
          license = lib.licenses.mit;
        };
      };

      dracula-theme.theme-dracula = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "theme-dracula";
          publisher = "dracula-theme";
          version = "2.22.3";
          useMSMktplc = true;
          sha256 = "0wni9sriin54ci8rly2s68lkfx8rj1cys6mgcizvps9sam6377w6";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/dracula-theme.theme-dracula/changelog";
          description = "Dark theme for many editors, shells, and more";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula";
          homepage = "https://draculatheme.com/";
          license = licenses.mit;
        };
      };

      eamodio.gitlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlens";
          publisher = "eamodio";
          version = "11.1.3";
          sha256 = "1x9bkf9mb56l84n36g3jmp3hyfbyi8vkm2d4wbabavgq6gg618l6";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      editorconfig.editorconfig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "EditorConfig";
          publisher = "EditorConfig";
          version = "0.16.4";
          sha256 = "08gk0wvzqijkkg4raccq6r4kvlidf14nhiq7ihwcgjl2iyp820z5";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/EditorConfig.EditorConfig/changelog";
          description = "EditorConfig Support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig";
          homepage = "https://github.com/editorconfig/editorconfig-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
        };
      };

      edonet.vscode-command-runner = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-command-runner";
          publisher = "edonet";
          version = "0.0.116";
          useMSMktplc = true;
          sha256 = "0fxvplyk080m0cdsvzynp6wjillrd4flr5qz7af7fibb2jbmfdkn";
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
          sha256 = "1jpr6y3bg3wh0yy923b2bkp2fbc8bibpr9rhpnq7ssi36dwabzk6";
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

      emmanuelbeziat.vscode-great-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-great-icons";
          publisher = "emmanuelbeziat";
          version = "2.1.64";
          sha256 = "0zzbkbnv2sglh86dsg1m15xacsnbxrmwwbmrsbk7bdnpgc30pksh";
        };
        meta = with lib; {
          license = licenses.mit;
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
          sha256 = "0blrb5frcmdnqm8lnxb0ijlh9xjqgd6insfmn9wgnxcl2is0wpg4";
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
          useMSMktplc = true;
          sha256 = "1lyx0l42xhi2f3rdnjddc3mw7m913kjnchawi98i6vqsx3dv7091";
        };
      };

      formulahendry.auto-close-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "auto-close-tag";
          publisher = "formulahendry";
          version = "0.5.6";
          sha256 = "1bws0v1v4zcc3bddx2i1yx88hkyv4zvy9whq5rh206s7fdn8w58f";
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
          useMSMktplc = true;
          sha256 = "0cqg9mxkyf41brjq2c764w42lzyn6ffphw6ciw7xnqk1h1x8wwbs";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      formulahendry.code-runner = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "code-runner";
          publisher = "formulahendry";
          version = "0.11.2";
          useMSMktplc = true;
          sha256 = "0qwcxr6m1xwhqmdl4pccjgpikpq1hgi2hgrva5abn8ixa2510hcy";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      foxundermoon.shell-format = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "shell-format";
          publisher = "foxundermoon";
          version = "7.1.0";
          # Open VSX Registry contains version 7.0.1
          # See https://github.com/foxundermoon/vs-shell-format/issues/103
          useMSMktplc = true;
          sha256 = "09z72mdr5bfdcb67xyzlv7lb9vyjlc3k9ackj4jgixfk40c68cnj";
        };
        meta = with lib; {
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format";
          homepage = "https://github.com/foxundermoon/vs-shell-format";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
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
          useMSMktplc = true;
          sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
        };
      };

      github = {
        github-vscode-theme = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "github-vscode-theme";
            publisher = "github";
            version = "4.1.1";
            # Open VSX Registry contains version 1.1.5
            # See https://github.com/primer/github-vscode-theme/issues/66
            # See https://github.com/open-vsx/publish-extensions/pull/63
            useMSMktplc = true;
            sha256 = "14wz2b0bn1rnmpj28c0mivz2gacla2dgg8ncv7qfx9bsxhf95g68";
          };
          meta = with lib; {
            description = "GitHub theme for VS Code";
            downloadPage =
              "https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme";
            homepage = "https://github.com/primer/github-vscode-theme";
            license = licenses.mit;
            maintainers = with maintainers; [ hugolgst ];
          };
        };

        vscode-pull-request-github = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-pull-request-github";
            publisher = "github";
            version = "0.22.0";
            sha256 = "13p3z86vkra26npp5a78pxdwa4z6jqjzsd38arhgdnjgwmi6bnrw";
          };
          meta = { license = lib.licenses.mit; };
        };
      };

      golang.Go = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Go";
          publisher = "golang";
          version = "0.18.1";
          sha256 = "16l2zmvc9128ndm00vfcl24phk6cqh4xzf3y9h44jldgl0yi5pvh";
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
          # Open VSX Registry contains version 0.3.8
          useMSMktplc = true;
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
          version = "0.0.213";
          useMSMktplc = true;
          sha256 = "0fj7vvaqdldhbzm9dqh2plqlhg34jv5khd690xd87h418sv8rk95";
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
          sha256 = "180lfcx2z8nrbg8g7ydzi9s9ijc1j7qs3frdn5krrwig1fmp5xiz";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      hashicorp.terraform = callPackage ./terraform { };

      hookyqr.beautify = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "beautify";
          publisher = "HookyQR";
          # Open VSX Registry contains version 1.4.11
          useMSMktplc = true;
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
          sha256 = "09j9npk35h4z1fw0n0jw9zc2lmk54jh5mf4g816sv3szyvypibf5";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      iciclesoft.workspacesort = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "workspacesort";
          publisher = "iciclesoft";
          version = "1.6.0";
          sha256 = "0iiara9ncbaryk66sszx3m1wzd54aqcc6idba7y82x8v2qi949w6";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/iciclesoft.workspacesort/changelog";
          description = "Sort workspace-folders alphabetically rather than in chronological order";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=iciclesoft.workspacesort";
          homepage = "https://github.com/iciclesoft/workspacesort-for-VSCode";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
        };
      };

      JakeBecker.elixir-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.7.0";
          sha256 = "sha256-kFrkElD7qC1SpOx1rpcHW1D2hybHCf7cqvIO7JfPuMc=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      james-yu.latex-workshop = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "latex-workshop";
          publisher = "James-Yu";
          version = "8.16.1";
          sha256 = "123h7x17dhy0f6znfyc0qcqf15861g72yi29ip6w461lqcf4i564";
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
          sha256 = "0xvw7wsivfpmix305x3va67n3iqg58whg2xvi1zvrzhpdj7c2j05";
        };
      };

      jock.svg = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svg";
          publisher = "jock";
          version = "1.4.4";
          # Open VSX Registry contains version 1.4.1
          useMSMktplc = true;
          sha256 = "0kn2ic7pgbd4rbvzpsxfwyiwxa1iy92l0h3jsppxc8gk8xbqm2nc";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      johnpapa.vscode-peacock = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-peacock";
          publisher = "johnpapa";
          version = "3.9.1";
          sha256 = "1g7apzzgfm8s9sjavhwr8jpf9slhq8b9jfkww3q5n41mzzx8m94p";
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
          useMSMktplc = true;
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
          version = "3.3.0";
          sha256 = "11jwxxkbsncx7f10hs97bsgy7sslir60jn3mm32n5awp49ia8vf9";
        };
        meta = {
          license = lib.licenses.bsd3;
        };
      };

      kahole.magit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "magit";
          publisher = "kahole";
          version = "0.6.13";
          sha256 = "sha256-/SeGQV0UEqBk69cAmUXFc/OfPxNssvzZqa7NmAMQD1k=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mikestead.dotenv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dotenv";
          publisher = "mikestead";
          version = "1.0.1";
          sha256 = "1ilp720bakyqwb29cxs1k7xsbqlill5j8dnk6bm839xzdvy394sk";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mishkinf.goto-next-previous-member = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "goto-next-previous-member";
          publisher = "mishkinf";
          version = "0.0.5";
          useMSMktplc = true;
          sha256 = "0kgzap1k924i95al0a63hxcsv8skhaapgfpi9d7vvaxm0fc10l1i";
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
          useMSMktplc = true;
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
          sha256 = "023bjm2ygcdqr85bmabwpg0dpa4vvi1834ci4kf1bq4qazv2p3fh";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-docker";
          publisher = "ms-azuretools";
          version = "1.9.1";
          sha256 = "1l7pm3s5kbf2vark164ykz4qbpa1ac9ls691hham36f6v91dmff9";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-dotnettools.csharp = callPackage ./ms-dotnettools-csharp { };

      ms-kubernetes-tools.vscode-kubernetes-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-kubernetes-tools";
          publisher = "ms-kubernetes-tools";
          version = "1.0.6";
          useMSMktplc = true;
          sha256 = "12a4phl1pddsajy3n0ld6rp607iy0pif6pqrs6ljbg2x97fyra28";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.cpptools = callPackage ./cpptools { };

      ms-vscode-remote.remote-ssh = callPackage ./remote-ssh { };

      ms-python.python =
        let
          raw-package = callPackage ./python {
            extractNuGet = callPackage ./python/extract-nuget.nix { };
          };
        in
        buildEnv {
          name = "vscode-extension-ms-python-python-full";
          paths = [ raw-package self.ms-toolsai.jupyter ];
        };

      msjsdiag.debugger-for-chrome = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "debugger-for-chrome";
          publisher = "msjsdiag";
          version = "4.12.11";
          useMSMktplc = true;
          sha256 = "sha256-9i3TgCFThnFF5ccwzS4ATj5c2Xoe/4tDFGv75jJxeQ4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.jupyter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jupyter";
          publisher = "ms-toolsai";
          version = "2021.5.745244803";
          useMSMktplc = true;
          sha256 = "0gjpsp61l8daqa87mpmxcrvsvb0pc2vwg7xbkvwn0f13c1739w9p";
        };
        meta = {
          license = lib.licenses.unfree;
        };
      };

      naumovs.color-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "color-highlight";
          publisher = "naumovs";
          version = "2.3.0";
          useMSMktplc = true;
          sha256 = "1syzf43ws343z911fnhrlbzbx70gdn930q67yqkf6g0mj8lf2za2";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      redhat.java = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "java";
          publisher = "redhat";
          version = "0.76.0";
          sha256 = "0xb9brki4s00piv4kqgz6idm16nk6x1j6502jljz7y9pif38z32y";
        };
        buildInputs = [ jdk ];
        meta = {
          license = lib.licenses.epl20;
          broken = lib.versionOlder jdk.version "11";
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
          useMSMktplc = true;
          sha256 = "0fqwcvwq37ndms6vky8jjv0zliy6fpfkh8d9raq8hkinfxq6klgl";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      matklad.rust-analyzer = callPackage ./rust-analyzer { };

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
          sha256 = "0zrvph567s4ss59apa1gv5y6shndg2xv2d46sii14cankx9mac9j";
        };
      };

      pkief.material-icon-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-icon-theme";
          publisher = "pkief";
          version = "4.4.0";
          sha256 = "1ahwlg6wks9ys5j34mjd9d0702a9qcp47qsnq8dk9r596kxdw2wl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      rubbersheep.gi = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gi";
          publisher = "rubbersheep";
          version = "0.2.11";
          useMSMktplc = true;
          sha256 = "0j9k6wm959sziky7fh55awspzidxrrxsdbpz1d79s5lr5r19rs6j";
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
          useMSMktplc = true;
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
          version = "0.5.3";
          useMSMktplc = true;
          sha256 = "0isw8jh845hj2fw7my1i19b710v3m5qsjy2faydb529ssdqv463p";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      scalameta.metals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "metals";
          publisher = "scalameta";
          version = "1.10.4";
          sha256 = "1n497nvliqpl1pkwrkcqaqq88khacf6h68jfdi4b7g36k55yw8pf";
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
          sha256 = "01602p3nvb4cakb7racmsi48vhkgpz20whb1f7ix8qxgw731clg7";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };


      shyykoserhiy.vscode-spotify = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-spotify";
          publisher = "shyykoserhiy";
          version = "3.2.1";
          useMSMktplc = true;
          sha256 = "14d68rcnjx4a20r0ps9g2aycv5myyhks5lpfz0syr2rxr4kd1vh6";
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
          useMSMktplc = true;
          sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      slevesque.vscode-multiclip = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-multiclip";
          publisher = "slevesque";
          version = "0.1.5";
          useMSMktplc = true;
          sha256 = "1cg8dqj7f10fj9i0g6mi3jbyk61rs6rvg9aq28575rr52yfjc9f9";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      spywhere.guides = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "guides";
          publisher = "spywhere";
          version = "0.9.3";
          useMSMktplc = true;
          sha256 = "1kvsj085w1xax6fg0kvsj1cizqh86i0pkzpwi0sbfvmcq21i6ghn";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      stephlin.vscode-tmux-keybinding = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tmux-keybinding";
          publisher = "stephlin";
          version = "0.0.6";
          sha256 = "0mph2nval1ddmv9hpl51fdvmagzkqsn8ljwqsfha2130bb7la0d9";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/stephlin.vscode-tmux-keybinding/changelog";
          description = "A simple extension for tmux behavior in vscode terminal.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stephlin.vscode-tmux-keybinding";
          homepage = "https://github.com/StephLin/vscode-tmux-keybinding";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
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

      svelte.svelte-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svelte-vscode";
          publisher = "svelte";
          version = "105.0.0";
          sha256 = "sha256-my3RzwUW5MnajAbEnqxtrIR701XH+AKYLbnKD7ivASE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "even-better-toml";
          publisher = "tamasfe";
          version = "0.9.3";
          useMSMktplc = true;
          sha256 = "16x2y58hkankazpwm93j8lqdn3mala7iayck548kki9zx4qrhhck";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tiehuis.zig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "zig";
          publisher = "tiehuis";
          version = "0.2.5";
          sha256 = "sha256-P8Sep0OtdchTfnudxFNvIK+SW++TyibGVI9zd+B5tu4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };


      timonwong.shellcheck = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "shellcheck";
          publisher = "timonwong";
          version = "0.12.3";
          sha256 = "1jj117rws51cvxlgsx680dcs30za4gax4bcpmbhk8bi3dnwvnyc4";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tomoki1207.pdf = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pdf";
          publisher = "tomoki1207";
          version = "1.1.0";
          sha256 = "0pcs4iy77v4f04f8m9w2rpdzfq7sqbspr7f2sm1fv7bm515qgsvb";
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
          useMSMktplc = true;
          sha256 = "0l4wibsjnlbzbrl1wcj18vnm1q4ygvxmh347jvzziv8f1l790qjl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      usernamehw.errorlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "errorlens";
          publisher = "usernamehw";
          version = "3.2.4";
          sha256 = "0lm1rc2h7h7pkvkw5hqikzm2i3mmsn59bj90cvxy4k1zpzqlgqkp";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vadimcn.vscode-lldb = callPackage ./vscode-lldb { };

      vincaslt.highlight-matching-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "highlight-matching-tag";
          publisher = "vincaslt";
          version = "0.10.0";
          sha256 = "0ci0nkazf4djgz3gld7m8c24r7i9kjicavidmd7bz493y9yc5pd9";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare-vsliveshare { };

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

      VSpaceCode.vspacecode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vspacecode";
          publisher = "VSpaceCode";
          version = "0.9.1";
          sha256 = "sha256-/qJKYXR0DznqwF7XuJsz+OghIBzdWjm6dAlaRX4wdRU=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      VSpaceCode.whichkey = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "whichkey";
          publisher = "VSpaceCode";
          version = "0.8.5";
          sha256 = "sha256-p5fukIfk/tZFQrkf6VuT4fjmeGtKAqHDh6r6ky847ks=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      wix.vscode-import-cost = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-import-cost";
          publisher = "wix";
          version = "2.15.0";
          sha256 = "0d3b6654cdck1syn74vmmd1jmgkrw5v4c4cyrhdxbhggkip732bc";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      xaver.clang-format = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "clang-format";
          publisher = "xaver";
          version = "1.9.0";
          useMSMktplc = true;
          sha256 = "abd0ef9176eff864f278c548c944032b8f4d8ec97d9ac6e7383d60c92e258c2f";
        };
        meta = with lib; {
          license = licenses.mit;
          maintainers = [ maintainers.zeratax ];
        };
      };

      xyz.local-history = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "local-history";
          publisher = "xyz";
          version = "1.8.1";
          sha256 = "0dycizjdfslslqc9z9jh6mmmyzm53xb5wc4fljkznq3ngx690qcw";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      yzhang.markdown-all-in-one = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-all-in-one";
          publisher = "yzhang";
          version = "3.4.0";
          sha256 = "1hwgyiqw0s14f5wn8jxbckrvjidpbnxsjj2rx7dppn5svsa6ymsc";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-theme";
          publisher = "zhuangtongfa";
          version = "3.9.12";
          sha256 = "0n7ksqsvkvkz1ix1f5020sg792k4lnz533hmx0gb92kk7rkzc9q4";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      llvm-org.lldb-vscode = llvmPackages_8.lldb;

      WakaTime.vscode-wakatime = callPackage ./wakatime { };

      wholroyd.jinja = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jinja";
          publisher = "wholroyd";
          version = "0.0.8";
          sha256 = "0aplj8bqwmn9lf39vpgjsgdsl87d4b3cb78mxrkva6i6bhyzs3i8";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };
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
