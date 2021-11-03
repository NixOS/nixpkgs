{ config
, lib
, buildEnv
, callPackage
, vscode-utils
, asciidoctor
, nodePackages
, jdk
, llvmPackages_8
, nixpkgs-fmt
, protobuf
, jq
, shellcheck
, moreutils
, racket-minimal
, clojure-lsp
}:

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
      _4ops.terraform = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "4ops";
          name = "terraform";
          version = "0.2.1";
          sha256 = "196026a89pizj8p0hqdgkyllj2spx2qwpynsaqjq17s8v15vk5dg";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

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
          sha256 = "1cy0qn8iyjrinscn9p5ckpsa2hyryapxfi7is6s2zk2mpligbb1d";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      angular.ng-template = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ng-template";
          publisher = "Angular";
          version = "12.2.0";
          sha256 = "sha256-CChkWKiLi/OcOm268d45pNwiyrKhztqYsQvJV/9z+Ag=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Angular.ng-template/changelog";
          description = "Editor services for Angular templates";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Angular.ng-template";
          homepage = "https://github.com/angular/vscode-ng-language-service";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      antfu = {
        icons-carbon = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "icons-carbon";
            publisher = "antfu";
            version = "0.2.2";
            sha256 = "0mfap16la09mn0jhvy8s3dainrmjz64vra7d0d4fbcpgg420kv3f";
          };
          meta = with lib; {
            license = licenses.mit;
          };
        };

        slidev = buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "antfu";
            name = "slidev";
            version = "0.3.2";
            sha256 = "sha256-vzmByEiKZIkd707Bs4RGQrMII5sghYlkQI6aAJOHFcY=";
          };
          meta = with lib; {
            license = licenses.mit;
          };
        };
      };

      arcticicestudio.nord-visual-studio-code = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nord-visual-studio-code";
          publisher = "arcticicestudio";
          version = "0.18.0";
          sha256 = "sha256-Uo6peR+2ZNX6nwJ0Yar32Pe0rfBZ+f6ef1cYhUvVUbE=";
        };
        meta = with lib; {
          description = "An arctic, north-bluish clean and elegant Visual Studio Code theme.";
          downloadPage =
            "https://marketplace.visualstudio.com/items?itemName=arcticicestudio.nord-visual-studio-code";
          homepage = "https://github.com/arcticicestudio/nord-visual-studio-code";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe ];
        };
      };

      arrterian.nix-env-selector = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nix-env-selector";
          publisher = "arrterian";
          version = "1.0.7";
          sha256 = "0e76885c9dbb6dca4eac8a75866ec372b948cc64a3a3845327d7c3ef6ba42a57";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      asciidoctor.asciidoctor-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "asciidoctor-vscode";
          publisher = "asciidoctor";
          version = "2.8.9";
          sha256 = "1xkxx5i3nhd0dzqhhdmx0li5jifsgfhv0p5h7xwsscz3gzgsdcyb";
        };

        postPatch = ''
          substituteInPlace dist/src/text-parser.js \
            --replace "get('asciidoctor_command', 'asciidoctor')" \
                      "get('asciidoctor_command', '${asciidoctor}/bin/asciidoctor')"
          substituteInPlace dist/src/commands/exportAsPDF.js \
            --replace "get('asciidoctorpdf_command', 'asciidoctor-pdf')" \
                      "get('asciidoctorpdf_command', '${asciidoctor}/bin/asciidoctor-pdf')"
        '';

        meta = with lib; {
          license = licenses.mit;
        };
      };

      asvetliakov.vscode-neovim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-neovim";
          publisher = "asvetliakov";
          version = "0.0.82";
          sha256 = "17f0jzg9vdbqdjnnc5i1q28ij2kckvvxi7fw9szmyy754f074jb1";
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

      b4dm4n.vscode-nixpkgs-fmt = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nixpkgs-fmt";
          publisher = "B4dM4n";
          version = "0.0.1";
          sha256 = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."nixpkgs-fmt.path".default = "${nixpkgs-fmt}/bin/nixpkgs-fmt"' package.json | sponge package.json
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
          sha256 = "1y8p4rr8qq5ng52g4pbx8ayq04gi2869wrx68k69rl7ga7bzcyp9";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      bbenoist.nix = buildVscodeMarketplaceExtension {
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

      betterthantomorrow.calva = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "calva";
          publisher = "betterthantomorrow";
          version = "2.0.205";
          sha256 = "sha256-umnG1uLB42fUNKjANaKcABjVmqbdOQakd/6TPsEpF9c";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration[0].properties."calva.clojureLspPath".default = "${clojure-lsp}/bin/clojure-lsp"' package.json | sponge package.json
        '';
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
          version = "0.6.13";
          sha256 = "098vrm28b7jpzk0c2d0cgxvdw4jsswzf18cx1m9jwsm1j40fp5f4";
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
          sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
        };
        meta = with lib; {
          license = licenses.mpl20;
        };
      };

      chenglou92.rescript-vscode = callPackage ./rescript { };

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

      codezombiech.gitignore = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitignore";
          publisher = "codezombiech";
          version = "0.6.0";
          sha256 = "0gnc0691pwkd9s8ldqabmpfvj0236rw7bxvkf0bvmww32kv1ia0b";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      coenraads.bracket-pair-colorizer = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/CoenraadS.bracket-pair-colorizer/changelog";
          description = "A customizable extension for colorizing matching brackets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer";
          homepage = "https://github.com/CoenraadS/BracketPair";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
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
          version = "0.2.1";
          sha256 = "0bfvzs4ac537zqhnqaa38jf4lhiy1fmqcv6lq89nnx8k963380z7";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      coolbear.systemd-unit-file = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "coolbear";
          name = "systemd-unit-file";
          version = "1.0.6";
          sha256 = "0sc0zsdnxi4wfdlmaqwb6k2qc21dgwx6ipvri36x7agk7m8m4736";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      dbaeumer.vscode-eslint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-eslint";
          publisher = "dbaeumer";
          version = "2.1.14";
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
          version = "0.42.1";
          sha256 = "c8c0647e0dd786fe68becca6dc73eade5f4220a26ab9faff8dd813a14b25df51";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      davidlday.languagetool-linter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "languagetool-linter";
          publisher = "davidlday";
          version = "0.18.0";
          sha256 = "sha256-AYINgq1BMfh7p4xhwSC2Www6dQvyQAGTA45HJsmMGDg=";
        };
        meta = with lib; {
          description = "LanguageTool integration for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=davidlday.languagetool-linter";
          homepage = "https://github.com/davidlday/vscode-languagetool-linter";
          license = licenses.asl20;
          maintainers = with maintainers; [ ebbertd ];
        };
      };

      denoland.vscode-deno = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-deno";
          publisher = "denoland";
          version = "3.9.1";
          sha256 = "sha256-OuGTjmJQFAWrYp7YnFpyo0NnnCcXYF8itYjGKMa3FCs=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/denoland.vscode-deno/changelog";
          description = "A language server client for Deno";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno";
          homepage = "https://github.com/denoland/vscode_deno";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
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

      divyanshuagrawal.competitive-programming-helper = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "competitive-programming-helper";
          publisher = "DivyanshuAgrawal";
          version = "5.8.5";
          sha256 = "25v2tdAX7fVl2B5nvOIKN9vP1G5rA0G67CiDQn9n9Uc=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/DivyanshuAgrawal.competitive-programming-helper/changelog";
          description = "Makes judging, compiling, and downloading problems for competitve programming easy. Also supports auto-submit for a few sites.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DivyanshuAgrawal.competitive-programming-helper";
          homepage = "https://github.com/agrawal-d/cph";
          license = licenses.gpl3;
          maintainers = with maintainers; [ arcticlimer ];
        };
      };

      donjayamanne.githistory = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/donjayamanne.githistory/changelog";
          description = "View git log, file history, compare branches or commits";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory";
          homepage = "https://github.com/DonJayamanne/gitHistoryVSCode/";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "githistory";
          publisher = "donjayamanne";
          version = "0.6.14";
          sha256 = "11x116hzqnhgbryp2kqpki1z5mlnwxb0ly9r1513m5vgbisrsn0i";
        };
      };

      dotjoshjohnson.xml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "xml";
          publisher = "dotjoshjohnson";
          version = "2.5.1";
          sha256 = "1v4x6yhzny1f8f4jzm4g7vqmqg5bqchyx4n25mkgvw2xp6yls037";
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
          version = "11.6.0";
          sha256 = "sha256-JxCNE/IL/v94xWmhebsRZo1Gw+nSSpDgZ41ZGongGVI=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/eamodio.gitlens/changelog";
          description = "GitLens supercharges the Git capabilities built into Visual Studio Code.";
          longDescription = ''
            Supercharge the Git capabilities built into Visual Studio Code — Visualize code authorship at a glance via Git
            blame annotations and code lens, seamlessly navigate and explore Git repositories, gain valuable insights via
            powerful comparison commands, and so much more
          '';
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens";
          homepage = "https://gitlens.amod.io/";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      editorconfig.editorconfig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "EditorConfig";
          publisher = "EditorConfig";
          version = "0.16.4";
          sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
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

      emmanuelbeziat.vscode-great-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-great-icons";
          publisher = "emmanuelbeziat";
          version = "2.1.79";
          sha256 = "1cr1pxgxlfr643sfxbcr2xd53s1dnzcpacjj0ffkgizfda2psy78";
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
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "8.0.1";
          sha256 = "017lqpmzjxq5f1zr49akcm9gfki0qq8v7pj7gks6a3szjdx16mnl";
        };
      };

      eugleo.magic-racket = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "magic-racket";
          publisher = "evzen-wybitul";
          version = "0.5.7";
          sha256 = "sha256-34/H0WgM73yzuOGU2w6Ipq7KuEBuN1bykcLGuvzY3mU=";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."magic-racket.general.racketPath".default = "${racket-minimal}/bin/racket"' package.json | sponge package.json
        '';
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/evzen-wybitul.magic-racket/changelog";
          description = "The best coding experience for Racket in VS Code ";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket";
          homepage = "https://github.com/Eugleo/magic-racket";
          license = licenses.agpl3Only;
        };
      };

      faustinoaq.lex-flex-yacc-bison = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "lex-flex-yacc-bison";
          publisher = "faustinoaq";
          version = "0.0.3";
          sha256 = "6254f52157dc796eae7bf135ac88c1c9cc19d884625331a1e634f9768722cc3d";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/faustinoaq.lex-flex-yacc-bison/changelog";
          description = "Language support for Lex, Flex, Yacc and Bison.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=faustinoaq.lex-flex-yacc-bison";
          homepage = "https://github.com/faustinoaq/vscode-lex-flex-yacc-bison";
          license = licenses.mit;
          maintainers = with maintainers; [ angustrau ];
        };
      };

      file-icons.file-icons = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/file-icons.file-icons/changelog";
          description = "File-specific icons in VSCode for improved visual grepping.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=file-icons.file-icons";
          homepage = "https://github.com/file-icons/vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "file-icons";
          publisher = "file-icons";
          version = "1.0.28";
          sha256 = "1lyx0l42xhi2f3rdnjddc3mw7m913kjnchawi98i6vqsx3dv7091";
        };
      };

      foam.foam-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "foam-vscode";
          publisher = "foam";
          version = "0.14.1";
          sha256 = "sha256-w9xGkezS3A9z6sTk8WWgW7g8qYX6mJFfRV0lv5cu160=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/foam.foam-vscode/changelog";
          description = "A personal knowledge management and sharing system for VSCode ";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=foam.foam-vscode";
          homepage = "https://foambubble.github.io/";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
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

      formulahendry.code-runner = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "code-runner";
          publisher = "formulahendry";
          version = "0.11.2";
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
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "reasonml";
          publisher = "freebroccolo";
          version = "1.0.38";
          sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
        };
      };

      jkillian.custom-local-formatters = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jkillian";
          name = "custom-local-formatters";
          version = "0.0.4";
          sha256 = "1pmqnc759fq86g2z3scx5xqpni9khcqi5z2kpl1kb7yygsv314gm";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      kamikillerto.vscode-colorize = buildVscodeMarketplaceExtension {
        mktplcRef = {
            name = "vscode-colorize";
            publisher = "kamikillerto";
            version = "0.11.1";
            sha256 = "1h82b1jz86k2qznprng5066afinkrd7j3738a56idqr3vvvqnbsm";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      github = {
        copilot = buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "github";
            name = "copilot";
            version = "1.4.2678";
            sha256 = "sha256-NryXLuMIZJngp2dBsGbNhBiblEthckw1Zk2vqMXIzFM=";
          };
          meta = { license = lib.licenses.unfree; };
        };

        github-vscode-theme = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "github-vscode-theme";
            publisher = "github";
            version = "4.1.1";
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

      golang.go = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Go";
          publisher = "golang";
          version = "0.25.1";
          sha256 = "sha256-ZDUWN9lzDnR77W7xcMFQaaFl/6Lf/x1jgaBkwZPqGGw=";
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
          version = "0.0.214";
          sha256 = "0rwxjnrl44rnhx3183037k6435xs4772p58a37azl5cahsyav1hk";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      haskell.haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "haskell";
          publisher = "haskell";
          version = "1.6.1";
          sha256 = "1l6nrbqkq1p62dkmzs4sy0rxbid3qa1104s3fd9fzkmc1sldzgsn";
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

      iciclesoft.workspacesort = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "workspacesort";
          publisher = "iciclesoft";
          version = "1.6.0";
          sha256 = "1pbk8kflywll6lqhmffz9yjf01dn8xq8sk6rglnfn2kl2ildfhh6";
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

      ionide.ionide-fsharp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Ionide-fsharp";
          publisher = "Ionide";
          version = "5.5.5";
          sha256 = "xrBNiIbZVJ0sGUk/4PudD8kSyX94QkrFtf7Ho/sB0Vs=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Ionide.Ionide-fsharp/changelog";
          description = "Enhanced F# Language Features for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Ionide.Ionide-fsharp";
          homepage = "https://ionide.io";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      elixir-lsp.vscode-elixir-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.8.0";
          sha256 = "sha256-VD1g4DJfA0vDJ0cyHFDEtCEqQo0nXfPC5vknEU91cPk=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      influxdata.flux = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "influxdata";
          name = "flux";
          version = "0.6.5";
          sha256 = "sha256-rKkZ7Sg8buryFtbIuKsrf3V3Rf7PP8hnbEIRFf4FvSM=";
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
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.1.16";
          sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp";
        };
      };

      jock.svg = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svg";
          publisher = "jock";
          version = "1.4.7";
          sha256 = "04ghqg4s7g7yylmvbxzwzpnyy4zin2bwlgvflh18m77w4j0ckpiq";
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
          version = "3.4.0";
          sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
        };
        meta = {
          license = lib.licenses.bsd3;
        };
      };

      kahole.magit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "magit";
          publisher = "kahole";
          version = "0.6.18";
          sha256 = "0sqzz5bbqqg60aypvwxcqnxrr72gmwfj9sv0amgkyaf60zg5sf7w";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      llvm-vs-code-extensions.vscode-clangd = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-clangd";
          publisher = "llvm-vs-code-extensions";
          version = "0.1.13";
          sha256 = "/MpwbM+obcD3uqk8hnDrnbEK9Jot4fMe4sNzLt6mVGI=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      lokalise.i18n-ally = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "i18n-ally";
          publisher = "Lokalise";
          version = "2.7.1";
          sha256 = "sha256-nHBYRSiPQ5ucWPr9VCUgMrosloLnVj40Fh+CEBvWONE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mads-hartmann.bash-ide-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mads-hartmann";
          name = "bash-ide-vscode";
          version = "1.11.0";
          sha256 = "1hq41fy2v1grjrw77mbs9k6ps6gncwlydm03ipawjnsinxc9rdkp";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      mhutchie.git-graph = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "git-graph";
          publisher = "mhutchie";
          version = "1.30.0";
          sha256 = "sha256-sHeaMMr5hmQ0kAFZxxMiRk6f0mfjkg2XMnA4Gf+DHwA=";
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
          sha256 = "sha256-dieCzNOIcZiTGu4Mv5zYlG7jLhaEsJR05qbzzzQ7RWc=";
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
          sha256 = "12a4phl1pddsajy3n0ld6rp607iy0pif6pqrs6ljbg2x97fyra28";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.cpptools = callPackage ./cpptools { };

      ms-vscode-remote.remote-ssh = callPackage ./remote-ssh { };

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

      ms-toolsai.jupyter = callPackage ./ms-toolsai-jupyter {};

      mvllow.rose-pine = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mvllow";
          name = "rose-pine";
          version = "1.3.6";
          sha256 = "sha256-pKrwiA/ZArBfumT0VTauhINSDEbABWgBBzTZEE07wzk=";
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

      octref.vetur = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vetur";
          publisher = "octref";
          version = "0.34.1";
          sha256 = "09w3bik1mxs7qac67wgrc58vl98ham3syrn2anycpwd7135wlpby";
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
          maintainers = with maintainers; [ ];
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

      rubbersheep.gi = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gi";
          publisher = "rubbersheep";
          version = "0.2.11";
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
          sha256 = "0q6zjpdi98png4vpzz39q85nxmsh3h1nnan58saz5rr83d6jgj89";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      serayuzgur.crates = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "crates";
          publisher = "serayuzgur";
          version = "0.5.9";
          sha256 = "0l26pyvw7n3bszf97yx6qps72acq112akg3q4jq5mvlibng1nwk0";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      shardulm94.trailing-spaces = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "shardulm94";
          name = "trailing-spaces";
          version = "0.3.1";
          sha256 = "0h30zmg5rq7cv7kjdr5yzqkkc1bs20d72yz9rjqag32gwf46s8b8";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      shyykoserhiy.vscode-spotify = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-spotify";
          publisher = "shyykoserhiy";
          version = "3.2.1";
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
          version = "105.3.0";
          sha256 = "11plqsj3c4dv0xg2d76pxrcn382qr9wbh1lhln2x8mzv840icvwr";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      svsool.markdown-memo = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-memo";
          publisher = "svsool";
          version = "0.3.9";
          sha256 = "sha256-BsKFHR3wkSRHS8QOi63vLwGj3T2CPzvqXhgtEOq6gJM=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/svsool.markdown-memo/changelog";
          description = "Markdown knowledge base with bidirectional [[link]]s built on top of VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=svsool.markdown-memo";
          homepage = "https://github.com/svsool/vscode-memo";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      tabnine.tabnine-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "tabnine-vscode";
          publisher = "tabnine";
          version = "3.4.27";
          sha256 = "sha256-Xg/N59a38OKEWb/4anysslensUoj9ENcuobkyByFDxE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      takayama.vscode-qq = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "takayama";
          name = "vscode-qq";
          version = "1.4.0";
          sha256 = "sha256-DYjNWSKOrDYvdiV7G24uKz6w4ggeYUMkQIiOGZAbMSI=";
        };
        meta = {
          license = lib.licenses.mpl20;
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
          version = "0.14.4";
          sha256 = "05z314sw9nqym3qlj7dcwm0fz1hb23xppzqn3nr2wcj17hs8zz4m";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."shellcheck.executablePath".default = "${shellcheck}/bin/shellcheck"' package.json | sponge package.json
        '';
        meta = {
          license = lib.licenses.mit;
        };
      };

      tobiasalthoff.atom-material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "atom-material-theme";
          publisher = "tobiasalthoff";
          version = "1.10.7";
          sha256 = "sha256-t5CKrDEbDCuo28wN+hiWrvkt3C9vQAPfV/nd3QBGQ/s=";
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
          version = "3.4.0";
          sha256 = "1x9rkyhbp15dwp6dikzpk9lzjnh9cnxac89gzx533681zld906m8";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/usernamehw.errorlens/changelog";
          description = "Improve highlighting of errors, warnings and other language diagnostics.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens";
          homepage = "https://github.com/usernamehw/vscode-error-lens";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe ];
        };
      };

      vadimcn.vscode-lldb = callPackage ./vscode-lldb { };

      viktorqvarfordt.vscode-pitch-black-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pitch-black-theme";
          publisher = "ViktorQvarfordt";
          version = "1.2.4";
          sha256 = "sha256-HTXToZv0WWFjuQiofEJuaZNSDTmCUcZ0B3KOn+CVALw=";
        };
        meta = {
          license = lib.licenses.mit;
        };
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

      ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare-vsliveshare { };

      vscodevim.vim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vim";
          publisher = "vscodevim";
          version = "1.21.5";
          sha256 = "1v1xs1wcigisr6xip31i02cfryxrb157sla34y59pwlnhc5x1gny";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.vspacecode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vspacecode";
          publisher = "VSpaceCode";
          version = "0.10.1";
          sha256 = "sha256-H7SCC/ZhDswMQjLX+qpQa6A1N83MobJRPC4pyIbZ1kA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.whichkey = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "whichkey";
          publisher = "VSpaceCode";
          version = "0.9.2";
          sha256 = "sha256-f+t2d8iWW88OYzuYFxzQPnmFMgx/DELBywYhA8A/0EU=";
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
          sha256 = "1mfmnbdv76nvwg4xs3rgsqbxk8hw9zr1b61har9c3pbk9r4cay7v";
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
          sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
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
          sha256 = "017h9hxplf2rhmlhn3vag0wypcx6gxi7p9fgllj5jzwrl2wsjl0g";
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
          sha256 = "1ln9gly5bb7nvbziilnay4q448h9npdh7sd9xy277122h0qawkci";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      zxh404.vscode-proto3 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-proto3";
          publisher = "zxh404";
          version = "0.5.4";
          sha256 = "08dfl5h1k6s542qw5qx2czm1wb37ck9w2vpjz44kp2az352nmksb";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties.protoc.properties.path.default = "${protobuf}/bin/protoc"' package.json | sponge package.json
        '';
        meta = {
          license = lib.licenses.mit;
        };
      };
    };

  aliases = self: super: {
    # aliases
    ms-vscode = lib.recursiveUpdate super.ms-vscode { inherit (super.golang) go; };
  };

  # TODO: add overrides overlay, so that we can have a generated.nix
  # then apply extension specific modifcations to packages.

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = lib.optionals (config.allowAliases or true) [ aliases ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
lib.fix toFix
