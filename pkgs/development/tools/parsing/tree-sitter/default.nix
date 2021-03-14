{ lib, stdenv
, fetchgit, fetchFromGitHub, fetchurl
, writeShellScript, runCommand, which, formats
, rustPlatform, jq, nix-prefetch-git, xe, curl, emscripten
, Security
, callPackage

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
  version = "0.18.2";
  sha256 = "1kh3bqn28nal3mmwszbih8hbq25vxy3zd45pzj904yf0ds5ql684";
  cargoSha256 = "06jbn4ai5lrxzv51vfjzjs7kgxw4nh2vbafc93gma4k14gggyygc";

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

  fetchGrammar = (v: fetchgit {inherit (v) url rev sha256 fetchSubmodules; });

  grammars =
    runCommand "grammars" {} (''
       mkdir $out
     '' + (lib.concatStrings (lib.mapAttrsToList
            (name: grammar: "ln -s ${fetchGrammar grammar} $out/${name}\n")
            (import ./grammars))));

  builtGrammars = let
    change = name: grammar:
      callPackage ./grammar.nix {} {
        language = name;
        inherit version;
        source = fetchGrammar grammar;
      };
  in
    lib.mapAttrs change (removeAttrs (import ./grammars) [
      # TODO these don't have parser.c in the same place as others.
      # They might require more elaborate builds?
      #  /nix/…/src/parser.c: No such file or directory
      "tree-sitter-typescript"
      #  /nix/…/src/parser.c: No such file or directory
      "tree-sitter-ocaml"
      # /nix/…/src/parser.c:1:10: fatal error: tree_sitter/parser.h: No such file or directory
      "tree-sitter-razor"
    ]);

in rustPlatform.buildRustPackage {
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
    inherit grammars;
    inherit builtGrammars;

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
    # Aarch has test failures with how tree-sitter compiles the generated C files
    broken = stdenv.isAarch64;
  };
}
