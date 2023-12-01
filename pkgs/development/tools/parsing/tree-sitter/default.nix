{ lib
, stdenv
, fetchgit
, fetchFromGitHub
, runCommand
, which
, rustPlatform
, emscripten
, Security
, callPackage
, linkFarm
, CoreServices
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
  version = "0.20.8";
  sha256 = "sha256-278zU5CLNOwphGBUa4cGwjBqRJ87dhHMzFirZB09gYM=";
  cargoSha256 = "sha256-0avy53pmR7CztDrL+5WAmlqpZwd/EA3Fh10hfPXyXZc=";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v${version}";
    inherit sha256;
    fetchSubmodules = true;
  };

  update-all-grammars = callPackage ./update.nix { };

  fetchGrammar = (v: fetchgit { inherit (v) url rev sha256 fetchSubmodules; });

  grammars =
    runCommand "grammars" { } (''
      mkdir $out
    '' + (lib.concatStrings (lib.mapAttrsToList
      (name: grammar: "ln -s ${if grammar ? src then grammar.src else fetchGrammar grammar} $out/${name}\n")
      (import ./grammars { inherit lib; }))));

  buildGrammar = callPackage ./grammar.nix { };

  builtGrammars =
    let
      build = name: grammar:
        buildGrammar {
          language = grammar.language or name;
          inherit version;
          src = grammar.src or (fetchGrammar grammar);
          location = grammar.location or null;
          generate = grammar.generate or false;
        };
      grammars' = import ./grammars { inherit lib; } // extraGrammars;
      grammars = grammars' //
        { tree-sitter-ocaml = grammars'.tree-sitter-ocaml // { location = "ocaml"; }; } //
        { tree-sitter-ocaml-interface = grammars'.tree-sitter-ocaml // { location = "interface"; }; } //
        { tree-sitter-org-nvim = grammars'.tree-sitter-org-nvim // { language = "org"; }; } //
        { tree-sitter-typescript = grammars'.tree-sitter-typescript // { location = "typescript"; }; } //
        { tree-sitter-tsx = grammars'.tree-sitter-typescript // { location = "tsx"; }; } //
        { tree-sitter-typst = grammars'.tree-sitter-typst // { generate = true; }; } //
        { tree-sitter-markdown = grammars'.tree-sitter-markdown // { location = "tree-sitter-markdown"; }; } //
        { tree-sitter-markdown-inline = grammars'.tree-sitter-markdown // { language = "markdown_inline"; location = "tree-sitter-markdown-inline"; }; } //
        { tree-sitter-wing = grammars'.tree-sitter-wing // { location = "libs/tree-sitter-wing"; generate = true; }; };
    in
    lib.mapAttrs build (grammars);

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

in
rustPlatform.buildRustPackage {
  pname = "tree-sitter";
  inherit src version cargoSha256;

  buildInputs =
    lib.optionals stdenv.isDarwin [ Security CoreServices ];
  nativeBuildInputs =
    [ which ]
    ++ lib.optionals webUISupport [ emscripten ];

  postPatch = lib.optionalString (!webUISupport) ''
    # remove web interface
    sed -e '/pub mod playground/d' \
        -i cli/src/lib.rs
    sed -e 's/playground,//' \
        -e 's/playground::serve(&current_dir.*$/println!("ERROR: web-ui is not available in this nixpkgs build; enable the webUISupport"); std::process::exit(1);/' \
        -i cli/src/main.rs
  '';

  # Compile web assembly with emscripten. The --debug flag prevents us from
  # minifying the JavaScript; passing it allows us to side-step more Node
  # JS dependencies for installation.
  preBuild = lib.optionalString webUISupport ''
    mkdir -p .emscriptencache
    export EM_CACHE=$(pwd)/.emscriptencache
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
    inherit grammars buildGrammar builtGrammars withPlugins allGrammars;

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
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ Profpatsch ];
  };
}
