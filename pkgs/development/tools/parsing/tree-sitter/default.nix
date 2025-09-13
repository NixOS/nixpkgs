{
  lib,
  stdenv,
  fetchgit,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  which,
  rustPlatform,
  emscripten,
  openssl,
  pkg-config,
  callPackage,
  linkFarm,
  substitute,
  installShellFiles,
  buildPackages,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  webUISupport ? false,
  extraGrammars ? { },

  # tests
  lunarvim,
}:

let
  # to update:
  # 1) change all these hashes
  # 2) nix-build -A tree-sitter.updater.update-all-grammars
  # 3) Set GITHUB_TOKEN env variable to avoid api rate limit (Use a Personal Access Token from https://github.com/settings/tokens It does not need any permissions)
  # 4) run the ./result script that is output by that (it updates ./grammars)
  version = "0.25.6";
  hash = "sha256-2/DF2xyiKi5HAqqeGt1TIMvAWFfZgcfVccK4zrTqq88=";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    tag = "v${version}";
    inherit hash;
    fetchSubmodules = true;
  };

  update-all-grammars = callPackage ./update.nix { };

  fetchGrammar =
    v:
    fetchgit {
      inherit (v)
        url
        rev
        sha256
        fetchSubmodules
        ;
    };

  grammars = runCommand "grammars" { } (
    ''
      mkdir $out
    ''
    + (lib.concatStrings (
      lib.mapAttrsToList (
        name: grammar: "ln -s ${grammar.src or (fetchGrammar grammar)} $out/${name}\n"
      ) (import ./grammars { inherit lib; })
    ))
  );

  buildGrammar = callPackage ./grammar.nix { };

  builtGrammars =
    let
      build =
        name: grammar:
        buildGrammar {
          language = grammar.language or name;
          inherit version;
          src = grammar.src or (fetchGrammar grammar);
          location = grammar.location or null;
          generate = grammar.generate or false;
        };
      grammars' = import ./grammars { inherit lib; } // extraGrammars;
      grammars =
        grammars'
        // {
          tree-sitter-latex = grammars'.tree-sitter-latex // {
            generate = true;
          };
        }
        // {
          tree-sitter-ocaml = grammars'.tree-sitter-ocaml // {
            location = "grammars/ocaml";
          };
        }
        // {
          tree-sitter-ocaml-interface = grammars'.tree-sitter-ocaml // {
            location = "grammars/interface";
          };
        }
        // {
          tree-sitter-org-nvim = grammars'.tree-sitter-org-nvim // {
            language = "tree-sitter-org";
          };
        }
        // {
          tree-sitter-typescript = grammars'.tree-sitter-typescript // {
            location = "typescript";
          };
        }
        // {
          tree-sitter-tsx = grammars'.tree-sitter-typescript // {
            location = "tsx";
          };
        }
        // {
          tree-sitter-markdown = grammars'.tree-sitter-markdown // {
            location = "tree-sitter-markdown";
          };
        }
        // {
          tree-sitter-markdown-inline = grammars'.tree-sitter-markdown // {
            language = "tree-sitter-markdown_inline";
            location = "tree-sitter-markdown-inline";
          };
        }
        // {
          tree-sitter-php = grammars'.tree-sitter-php // {
            location = "php";
          };
        }
        // {
          tree-sitter-sql = grammars'.tree-sitter-sql // {
            generate = true;
          };
        };
    in
    lib.mapAttrs build grammars;

  # Usage:
  # pkgs.tree-sitter.withPlugins (p: [ p.tree-sitter-c p.tree-sitter-java ... ])
  #
  # or for all grammars:
  # pkgs.tree-sitter.withPlugins (_: allGrammars)
  # which is equivalent to
  # pkgs.tree-sitter.withPlugins (p: builtins.attrValues p)
  withPlugins =
    grammarFn:
    let
      grammars = grammarFn builtGrammars;
    in
    linkFarm "grammars" (
      map (
        drv:
        let
          name = lib.strings.getName drv;
        in
        {
          name =
            (lib.strings.replaceStrings [ "-" ] [ "_" ] (
              lib.strings.removePrefix "tree-sitter-" (lib.strings.removeSuffix "-grammar" name)
            ))
            + ".so";
          path = "${drv}/parser";
        }
      ) grammars
    );

  allGrammars = builtins.attrValues builtGrammars;

in
rustPlatform.buildRustPackage {
  pname = "tree-sitter";
  inherit src version;

  cargoHash = "sha256-sGh16M7cbT5ct1sT2FcUUoIQFcoOftTuQ0aSCjtkTEs=";

  buildInputs = [
    installShellFiles
  ]
  ++ lib.optionals webUISupport [
    openssl
  ];
  nativeBuildInputs = [
    which
  ]
  ++ lib.optionals webUISupport [
    emscripten
    pkg-config
  ];

  patches = lib.optionals (!webUISupport) [
    (substitute {
      src = ./remove-web-interface.patch;
    })
  ];

  postPatch = lib.optionalString webUISupport ''
    substituteInPlace cli/loader/src/lib.rs \
        --replace-fail 'let emcc_name = if cfg!(windows) { "emcc.bat" } else { "emcc" };' 'let emcc_name = "${lib.getExe' emscripten "emcc"}";'
  '';

  # Compile web assembly with emscripten. The --debug flag prevents us from
  # minifying the JavaScript; passing it allows us to side-step more Node
  # JS dependencies for installation.
  preBuild = lib.optionalString webUISupport ''
    mkdir -p .emscriptencache
    export EM_CACHE=$(pwd)/.emscriptencache
    cargo run --package xtask -- build-wasm --debug
  '';

  postInstall = ''
    PREFIX=$out make install
    ${lib.optionalString (!enableShared) "rm $out/lib/*.so{,.*}"}
    ${lib.optionalString (!enableStatic) "rm $out/lib/*.a"}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tree-sitter \
      --bash <("$out/bin/tree-sitter" complete --shell bash) \
      --zsh <("$out/bin/tree-sitter" complete --shell zsh) \
      --fish <("$out/bin/tree-sitter" complete --shell fish)
  ''
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tree-sitter \
      --bash "${buildPackages.tree-sitter}"/share/bash-completion/completions/*.bash \
      --zsh "${buildPackages.tree-sitter}"/share/zsh/site-functions/* \
      --fish "${buildPackages.tree-sitter}"/share/fish/*/*
  '';

  # test result: FAILED. 120 passed; 13 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  passthru = {
    updater = {
      inherit update-all-grammars;
    };
    inherit
      grammars
      buildGrammar
      builtGrammars
      withPlugins
      allGrammars
      ;

    updateScript = nix-update-script { };

    tests = {
      # make sure all grammars build
      builtGrammars = lib.recurseIntoAttrs builtGrammars;

      inherit lunarvim;
    };
  };

  meta = {
    homepage = "https://github.com/tree-sitter/tree-sitter";
    description = "Parser generator tool and an incremental parsing library";
    mainProgram = "tree-sitter";
    changelog = "https://github.com/tree-sitter/tree-sitter/releases/tag/v${version}";
    longDescription = ''
      Tree-sitter is a parser generator tool and an incremental parsing library.
      It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.

      Tree-sitter aims to be:

      * General enough to parse any programming language
      * Fast enough to parse on every keystroke in a text editor
      * Robust enough to provide useful results even in the presence of syntax errors
      * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Profpatsch
      uncenter
      amaanq
    ];
  };
}
