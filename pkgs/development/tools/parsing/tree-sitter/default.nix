{ lib
, stdenv
, fetchgit
, fetchFromGitHub
, fetchurl
, writeShellScript
, runCommand
, which
, formats
, rustPlatform
, jq
, nix-prefetch-git
, xe
, curl
, emscripten
, Security
, callPackage
, linkFarm
, writeTextFile
, writeShellApplication
, tree-sitter
, gcc

, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic
, webUISupport ? false
, extraGrammars ? { }
}:

let
  # to update:
  # 1) change all these hashes
  # 2) nix-build -A tree-sitter.updater.update-all-grammars
  # 3) Set GITHUB_TOKEN env variable to avoid api rate limit (Use a Personal Access Token from https://github.com/settings/tokens It does not need any permissions)
  # 4) run the ./result script that is output by that (it updates ./grammars)
  version = "0.20.7";
  sha256 = "sha256-5ILiN5EfJ7WpeYBiXynfcLucdp8zmxVOj4gLkaFQYts=";
  cargoSha256 = "sha256-V4frCaU5QzTx3ujdaplw7vNkosbzyXHQvE+T7ntVOtU=";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v${version}";
    inherit sha256;
    fetchSubmodules = true;
  };

  update-all-grammars = callPackage ./update.nix { };

  fetchGrammar = (v: fetchgit { inherit (v) url rev sha256 fetchSubmodules; });

  grammars' = (import ./grammars { inherit lib; } // extraGrammars);

  # Override the location of some grammars since they often are located in a sub-directory
  grammarsWithOverrides = grammars' //
    { tree-sitter-ocaml = grammars'.tree-sitter-ocaml // { location = "ocaml"; }; } //
    { tree-sitter-ocaml-interface = grammars'.tree-sitter-ocaml // { location = "interface"; }; } //
    { tree-sitter-org-nvim = grammars'.tree-sitter-org-nvim // { language = "org"; }; } //
    { tree-sitter-typescript = grammars'.tree-sitter-typescript // { location = "typescript"; }; } //
    { tree-sitter-tsx = grammars'.tree-sitter-typescript // { location = "tsx"; }; } //
    { tree-sitter-markdown = grammars'.tree-sitter-markdown // { location = "tree-sitter-markdown"; }; } //
    { tree-sitter-markdown-inline = grammars'.tree-sitter-markdown // { language = "markdown_inline"; location = "tree-sitter-markdown-inline"; }; };

  # Fetch their respective sources
  grammarSources = builtins.mapAttrs (name: grammar: if grammar ? src then grammar.src else fetchGrammar grammar) grammarsWithOverrides;
  grammars = linkFarm "grammars" grammarSources;

  buildGrammar = callPackage ./grammar.nix { };
  builtGrammars =
    let
      build = name: grammar:
        buildGrammar {
          language = grammar.language or name;
          inherit version;
          src = grammarSources.${name};
          location = grammar.location or null;
        };
    in
    lib.mapAttrs build (grammarsWithOverrides);

  # Usage:
  # pkgs.tree-sitter.withPlugins (p: [ p.tree-sitter-c p.tree-sitter-java ... ])
  #
  # or for all grammars:
  # pkgs.tree-sitter.withPlugins (_: allGrammars)
  # which is equivalent to
  # pkgs.tree-sitter.withPlugins (p: builtins.attrValues p)
  withPlugins = grammarFn:
    let
      grammars = grammarFn builtGrammars;
    in
    linkFarm "grammars"
      (map
        (drv:
          let
            name = lib.strings.getName drv;
          in
          {
            name =
              (lib.strings.replaceStrings [ "-" ] [ "_" ]
                (lib.strings.removePrefix "tree-sitter-"
                  (lib.strings.removeSuffix "-grammar" name)))
              + ".so";
            path = "${drv}/parser";
          }
        )
        grammars);

  allGrammars = builtins.attrValues builtGrammars;


  configWithGrammarSources = grammarFn:
    let
      # Since names aren't readable from the imported object, map each
      # object to { "tree-sitter-xyz": "tree-sitter-xyz" }
      selectedNames = grammarFn (builtins.mapAttrs (k: v: k) grammarSources);
      selectedGrammars = builtins.listToAttrs (builtins.map (x: { name = x; value = grammarSources.${x}; }) selectedNames);
    in
    writeTextFile {
      name = "tree-sitter-config";
      text = ''
        {
          "parser-directories": [
            "${linkFarm "grammars" selectedGrammars}"
          ]
        }
      '';
      destination = "/config.json";
    };


  # The tree-sitter command-line tool allows running queries on source code, and
  # generating ctags-compatible files. In order to do that it needs grammar sources
  # By default, the derivation doesn't have the required links to allow the binary to
  # find its configuration.
  #
  # With this wrapper one can directly run the command line tool as such:
  # $ nix run nixpkgs#tree-sitter.withAllGrammarSources -- tags /path/to/file
  #
  # If needed, one can select the individual sources using:
  # pkgs.tree-sitter.withGrammarSources(p: [ p.tree-sitter-c p.tree-sitter-java ... ])
  withGrammarSources = grammarFn: writeShellApplication {
    name = "tree-sitter";
    runtimeInputs = [ tree-sitter gcc ];
    text = ''
      export TREE_SITTER_DIR=${configWithGrammarSources grammarFn};
      ${tree-sitter}/bin/tree-sitter "$@"
    '';
  };

  allGrammarSources = builtins.attrNames grammarSources;
  withAllGrammarSources = withGrammarSources (_: allGrammarSources);
in
rustPlatform.buildRustPackage {
  pname = "tree-sitter";
  inherit src version cargoSha256;

  buildInputs =
    lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs =
    [ which ]
    ++ lib.optionals webUISupport [ emscripten ];

  postPatch = lib.optionalString (!webUISupport) ''
    # remove web interface
    sed -e '/pub mod web_ui/d' \
        -i cli/src/lib.rs
    sed -e 's/web_ui,//' \
        -e 's/web_ui::serve(&current_dir.*$/println!("ERROR: web-ui is not available in this nixpkgs build; enable the webUISupport"); std::process::exit(1);/' \
        -i cli/src/main.rs
  '';

  # Compile web assembly with emscripten. The --debug flag prevents us from
  # minifying the JavaScript; passing it allows us to side-step more Node
  # JS dependencies for installation.
  preBuild = lib.optionalString webUISupport ''
    bash ./script/build-wasm --debug
  '';

  postInstall = ''
    PREFIX=$out make install
    ${lib.optionalString (!enableShared) "rm $out/lib/*.so{,.*}"}
    ${lib.optionalString (!enableStatic) "rm $out/lib/*.a"}
  '';

  # test result: FAILED. 120 passed; 13 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  passthru = {
    updater = {
      inherit update-all-grammars;
    };
    inherit grammars buildGrammar builtGrammars withPlugins allGrammars grammarSources withGrammarSources withAllGrammarSources;

    tests = {
      # make sure all grammars build
      builtGrammars = lib.recurseIntoAttrs builtGrammars;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/tree-sitter/tree-sitter";
    description = "A parser generator tool and an incremental parsing library";
    longDescription = ''
      Tree-sitter is a parser generator tool and an incremental parsing library.
      It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.

      Tree-sitter aims to be:

      * General enough to parse any programming language
      * Fast enough to parse on every keystroke in a text editor
      * Robust enough to provide useful results even in the presence of syntax errors
      * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application

      In order to use the command-line tool, import pkgs.tree-sitter.withAllGrammarSources, or pick individual languages with
      pkgs.tree-sitter.withGrammarSources(p: [ p.tree-sitter-c p.tree-sitter-java ... ]). A valid configuration will be generated and
      used automatically.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ Profpatsch oxalica ];
  };
}
