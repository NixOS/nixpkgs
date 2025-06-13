{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchFromSourcehut,
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
  makeOverridable,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  webUISupport ? false,

  # tests
  lunarvim,
}:

let
  /**
    Build a parser grammar and put the resulting shared object in `$out/parser`.

    # Example

    ```nix
    tree-sitter-foo = pkgs.tree-sitter.buildGrammar {
      language = "foo";
      version = "0.42.0";
      src = fetchFromGitHub { ... };
    };
    ```
  */
  buildGrammar = callPackage ./build-grammar.nix { };

  /**
    Attrset of grammar sources.

    Values are of the form { language, version, src }. These may be referenced
    directly by other areas of the tree-sitter ecosystem in nixpkgs. Src will
    contain all language bindings provided by the upstream grammar.

    Use pkgs.tree-sitter.grammars.<name> to access.
  */
  grammars = import ./grammars {
    inherit
      lib
      nix-update-script
      fetchFromGitHub
      fetchFromGitLab
      fetchFromSourcehut
      ;
  };

  /**
    Attrset of compiled grammars.

    Compiled grammars contain the pre-built shared library and any queries from
    the grammar source.

    Use pkgs.tree-sitter-grammars.<name> to access.
  */
  builtGrammars = lib.mapAttrs (_: makeOverridable buildGrammar) grammars;

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
rustPlatform.buildRustPackage (final: {
  pname = "tree-sitter";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    tag = "v${final.version}";
    hash = "sha256-xafeni6Z6QgPiKzvhCT2SyfPn0agLHo47y+6ExQXkzE=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rjUn8F6WSxLQGrFzK23q4ClLePSpcMN2+i7rC02Fisk=";

  buildInputs =
    [ installShellFiles ]
    ++ lib.optionals webUISupport [
      openssl
    ];
  nativeBuildInputs =
    [ which ]
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

  postInstall =
    ''
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
    changelog = "https://github.com/tree-sitter/tree-sitter/releases/tag/v${final.version}";
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
    ];
  };
})
