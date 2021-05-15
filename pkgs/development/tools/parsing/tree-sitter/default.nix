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

, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic
, webUISupport ? false
}:

# TODO: move to carnix or https://github.com/kolloch/crate2nix
let
  # to update:
  # 1) change all these hashes
  # 2) nix-build -A tree-sitter.updater.update-all-grammars
  # 3) run the ./result script that is output by that (it updates ./grammars)
  version = "0.19.3";
  sha256 = "0zd1p9x32bwdc5cdqr0x8i9fpcykk1zczb8zdjawrrr92465d26y";
  cargoSha256 = "0mlrbl85x1x2ynwrps94mxn95rjj1r7gb3vdivfaxqv1xvp25m41";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v${version}";
    inherit sha256;
    fetchSubmodules = true;
  };

  update-all-grammars = import ./update.nix {
    inherit writeShellScript nix-prefetch-git curl jq xe src formats lib;
  };

  fetchGrammar = (v: fetchgit { inherit (v) url rev sha256 fetchSubmodules; });

  grammars =
    runCommand "grammars" { } (''
      mkdir $out
    '' + (lib.concatStrings (lib.mapAttrsToList
      (name: grammar: "ln -s ${fetchGrammar grammar} $out/${name}\n")
      (import ./grammars))));

  builtGrammars =
    let
      change = name: grammar:
        callPackage ./grammar.nix { } {
          language = name;
          inherit version;
          source = fetchGrammar grammar;
          location = if grammar ? location then grammar.location else null;
        };
      grammars' = (import ./grammars);
      grammars = grammars' //
        { tree-sitter-ocaml = grammars'.tree-sitter-ocaml // { location = "ocaml"; }; } //
        { tree-sitter-ocaml-interface = grammars'.tree-sitter-ocaml // { location = "interface"; }; } //
        { tree-sitter-typescript = grammars'.tree-sitter-typescript // { location = "typescript"; }; } //
        { tree-sitter-tsx = grammars'.tree-sitter-typescript // { location = "tsx"; }; };
    in
    lib.mapAttrs change grammars;

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
              (lib.strings.removePrefix "tree-sitter-"
                (lib.strings.removeSuffix "-grammar" name))
              + stdenv.hostPlatform.extensions.sharedLibrary;
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
    inherit grammars builtGrammars withPlugins allGrammars;

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
